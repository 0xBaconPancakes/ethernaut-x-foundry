// SPDX-License-Identifier: MIT

pragma solidity ^0.8.10;

import "ds-test/test.sol";
import "../King/King.sol";
import "../King/KingAttack.sol";
import "../King/KingFactory.sol";
import "../Ethernaut.sol";
import "./utils/vm.sol";

contract KingTest is DSTest {
    Vm vm = Vm(address(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D));
    Ethernaut ethernaut;

    function setUp() public {
        // Setup instance of the Ethernaut contracts
        ethernaut = new Ethernaut();
    }

    function testKingAttack() public {
        /////////////////
        // LEVEL SETUP //
        /////////////////

        KingFactory kingFactory = new KingFactory();
        ethernaut.registerLevel(kingFactory);
        vm.startPrank(tx.origin);
        address levelAddress = ethernaut.createLevelInstance{value: 1 ether}(kingFactory);
        King king = King(payable(levelAddress));

        //////////////////
        // LEVEL ATTACK //
        //////////////////

        KingAttack kingAttack = new KingAttack();
        uint256 higherPrize = king.prize() + 1;
        kingAttack.becomeKing{value: higherPrize}(address(king));
        
        //////////////////////
        // LEVEL SUBMISSION //
        //////////////////////

        bool levelSuccessfullyPassed = ethernaut.submitLevelInstance(payable(levelAddress));
        vm.stopPrank();
        assert(levelSuccessfullyPassed);
    }
}