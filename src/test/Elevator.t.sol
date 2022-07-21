// SPDX-License-Identifier: MIT

pragma solidity ^0.8.10;

import "ds-test/test.sol";
import "../Elevator/Elevator.sol";
import "../Elevator/ElevatorHack.sol";
import "../Elevator/ElevatorFactory.sol";
import "../Ethernaut.sol";
import "./utils/vm.sol";

contract ElevatorTest is DSTest {
    Vm vm = Vm(address(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D));
    Ethernaut ethernaut;

    function setUp() public {
        // Setup instance of the Ethernaut contracts
        ethernaut = new Ethernaut();
    }

    function testElevatorHack() public {
        /////////////////
        // LEVEL SETUP //
        /////////////////

        ElevatorFactory elevatorFactory = new ElevatorFactory();
        ethernaut.registerLevel(elevatorFactory);
        vm.startPrank(tx.origin);
        address levelAddress = ethernaut.createLevelInstance{value: 1 ether}(elevatorFactory);

        //////////////////
        // LEVEL ATTACK //
        //////////////////

        ElevatorHack elevatorHack = new ElevatorHack(levelAddress);
        elevatorHack.attack();
        
        //////////////////////
        // LEVEL SUBMISSION //
        //////////////////////

        bool levelSuccessfullyPassed = ethernaut.submitLevelInstance(payable(levelAddress));
        vm.stopPrank();
        assert(levelSuccessfullyPassed);
    }
}