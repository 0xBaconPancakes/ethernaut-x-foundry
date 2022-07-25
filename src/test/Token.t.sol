// SPDX-License-Identifier: MIT

pragma solidity ^0.8.10;

import "ds-test/test.sol";
import "../Token/Token.sol";
import "../Token/TokenAttack.sol";
import "../Token/TokenFactory.sol";
import "../Ethernaut.sol";
import "./utils/vm.sol";

contract TokenTest is DSTest {
    Vm vm = Vm(address(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D));
    Ethernaut ethernaut;

    function setUp() public {
        // Setup instance of the Ethernaut contracts
        ethernaut = new Ethernaut();
    }

    function testTokenAttack() public {
        /////////////////
        // LEVEL SETUP //
        /////////////////

        TokenFactory tokenFactory = new TokenFactory();
        ethernaut.registerLevel(tokenFactory);
        vm.startPrank(tx.origin);
        address levelAddress = ethernaut.createLevelInstance(tokenFactory);

        //////////////////
        // LEVEL ATTACK //
        //////////////////

        TokenAttack tokenAttack = new TokenAttack(levelAddress);
        tokenAttack.attack();
        
        //////////////////////
        // LEVEL SUBMISSION //
        //////////////////////

        bool levelSuccessfullyPassed = ethernaut.submitLevelInstance(payable(levelAddress));
        vm.stopPrank();
        assert(levelSuccessfullyPassed);
    }
}