// SPDX-License-Identifier: MIT

pragma solidity ^0.8.10;

import "ds-test/test.sol";
import "../Preservation/PreservationAttack.sol";
import "../Preservation/PreservationFactory.sol";
import "../Ethernaut.sol";
import "./utils/vm.sol";

contract PreservationTest is DSTest {
    Vm vm = Vm(address(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D));
    Ethernaut ethernaut;

    function setUp() public {
        // Setup instance of the Ethernaut contracts
        ethernaut = new Ethernaut();
    }

    function testPreservationAttack() public {
        /////////////////
        // LEVEL SETUP //
        /////////////////

        PreservationFactory preservationFactory = new PreservationFactory();
        ethernaut.registerLevel(preservationFactory);
        vm.startPrank(tx.origin);
        address levelAddress = ethernaut.createLevelInstance(preservationFactory);
        // Preservation preservation = Preservation(payable(levelAddress));

        //////////////////
        // LEVEL ATTACK //
        //////////////////

        PreservationAttack preservationAttack = new PreservationAttack();
        preservationAttack.attack(levelAddress);

        //////////////////////
        // LEVEL SUBMISSION //
        //////////////////////

        bool levelSuccessfullyPassed = ethernaut.submitLevelInstance(payable(levelAddress));
        vm.stopPrank();
        assert(levelSuccessfullyPassed);
    }
}