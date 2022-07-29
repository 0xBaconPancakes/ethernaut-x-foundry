// SPDX-License-Identifier: MIT

pragma solidity ^0.8.10;

import "ds-test/test.sol";
import "../Dex/Dex.sol";
import "../Dex/DexAttack.sol";
import "../Dex/DexFactory.sol";
import "../Ethernaut.sol";
import "./utils/vm.sol";

contract DexTest is DSTest {
    Vm vm = Vm(address(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D));
    Ethernaut ethernaut;

    function setUp() public {
        // Setup instance of the Ethernaut contracts
        ethernaut = new Ethernaut();
    }

    function testDexAttack() public {
        /////////////////
        // LEVEL SETUP //
        /////////////////

        DexFactory dexFactory = new DexFactory();
        ethernaut.registerLevel(dexFactory);
        vm.startPrank(tx.origin);
        address _dex = ethernaut.createLevelInstance(dexFactory);
        Dex dex = Dex(_dex);

        //////////////////
        // LEVEL ATTACK //
        //////////////////

        DexAttack dexAttack = new DexAttack();

        IERC20 token1 = IERC20(dex.token1());
        IERC20 token2 = IERC20(dex.token2());

        token1.transfer(address(dex), token1.balanceOf(msg.sender));
        token2.transfer(address(dexAttack), token2.balanceOf(msg.sender));
        dexAttack.attack(_dex);

        //////////////////////
        // LEVEL SUBMISSION //
        //////////////////////

        bool levelSuccessfullyPassed = ethernaut.submitLevelInstance(payable(_dex));
        vm.stopPrank();
        assert(levelSuccessfullyPassed);
    }
}