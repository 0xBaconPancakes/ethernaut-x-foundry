// SPDX-License-Identifier: MIT

pragma solidity ^0.8.10;

import "ds-test/test.sol";
import "../MagicNum/MagicNumFactory.sol";
import "../Ethernaut.sol";
import "./utils/vm.sol";

contract MagicNumTest is DSTest {
    Vm vm = Vm(address(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D));
    Ethernaut ethernaut;
    address eoaAddress = address(100);

    function setUp() public {
        // Setup instance of the Ethernaut contract
        ethernaut = new Ethernaut();
        // Deal EOA address some ether
        vm.deal(eoaAddress, 5 ether);
    }

    function testMagicNumAttack() public {
        /////////////////
        // LEVEL SETUP //
        /////////////////

        MagicNumFactory magicNumFactory = new MagicNumFactory();
        ethernaut.registerLevel(magicNumFactory);
        vm.startPrank(eoaAddress);
        address levelAddress = ethernaut.createLevelInstance{value : 0.001 ether}(magicNumFactory);
        MagicNum magicNum = MagicNum(payable(levelAddress));

        //////////////////
        // LEVEL ATTACK //
        //////////////////

        // Code generated with 'solc --strict-assembly --optimize yul/MagicNum/MagicNumAttack.yul'
        // Note that storing the value 0x2a in the memory location 0x0 is saving 12 gas!q
        bytes memory code = hex"600a80600c6000396000f3fe602a60005260206000f3";

        address addr;
        assembly {
            addr := create(0, add(code, 0x20), mload(code))
        }
        magicNum.setSolver(addr);

        //////////////////////
        // LEVEL SUBMISSION //
        //////////////////////

        bool levelSuccessfullyPassed = ethernaut.submitLevelInstance(payable(levelAddress));
        vm.stopPrank();
        assert(levelSuccessfullyPassed);
    }
}
