// SPDX-License-Identifier: MIT

pragma solidity ^0.8.10;

import "ds-test/test.sol";
import "../Shop/Shop.sol";
import "../Shop/ShopAttack.sol";
import "../Shop/ShopFactory.sol";
import "../Ethernaut.sol";
import "./utils/vm.sol";

contract ShopTest is DSTest {
    Vm vm = Vm(address(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D));
    Ethernaut ethernaut;

    function setUp() public {
        // Setup instance of the Ethernaut contracts
        ethernaut = new Ethernaut();
    }

    function testShopAttack() public {
        /////////////////
        // LEVEL SETUP //
        /////////////////

        ShopFactory shopFactory = new ShopFactory();
        ethernaut.registerLevel(shopFactory);
        vm.startPrank(tx.origin);
        address levelAddress = ethernaut.createLevelInstance{value : 1 ether}(shopFactory);

        //////////////////
        // LEVEL ATTACK //
        //////////////////

        ShopAttack shopAttack = new ShopAttack();
        shopAttack.attack(levelAddress);

        //////////////////////
        // LEVEL SUBMISSION //
        //////////////////////

        bool levelSuccessfullyPassed = ethernaut.submitLevelInstance(payable(levelAddress));
        vm.stopPrank();
        assert(levelSuccessfullyPassed);
    }
}