// SPDX-License-Identifier: MIT

pragma solidity ^0.8.10;

import "ds-test/test.sol";
import "../DoubleEntryPoint/DoubleEntryPoint.sol";
import "../DoubleEntryPoint/DoubleEntryPointDetectionBot.sol";
import "../DoubleEntryPoint/DoubleEntryPointFactory.sol";
import "openzeppelin-contracts/contracts/utils/Address.sol";
import "../Ethernaut.sol";
import "./utils/vm.sol";


contract DoubleEntryPointTest is DSTest {
    Vm vm = Vm(address(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D));
    Ethernaut ethernaut;
    address eoaAddress = address(0x1234123412341234123412341234123412341234);

    function setUp() public {
        // Setup instance of the Ethernaut contract
        ethernaut = new Ethernaut();
        // Deal EOA address some ether
        vm.deal(eoaAddress, 5 ether);
    }

    function testDoubleEntryPointAttack() public {
        /////////////////
        // LEVEL SETUP //
        /////////////////

        DoubleEntryPointFactory doubleEntryPointFactory = new DoubleEntryPointFactory();
        ethernaut.registerLevel(doubleEntryPointFactory);
        vm.startPrank(eoaAddress);
        address _doubleEntryPoint = ethernaut.createLevelInstance(doubleEntryPointFactory);
        DoubleEntryPoint doubleEntryPoint = DoubleEntryPoint(_doubleEntryPoint);

        //////////////////
        // LEVEL ATTACK //
        //////////////////

        IForta forta = IForta(doubleEntryPoint.forta());
        emit log_named_address("forta", address(forta));
        emit log_named_address("vault", address(doubleEntryPoint.cryptoVault()));

        DoubleEntryPointDetectionBot detectionBot = new DoubleEntryPointDetectionBot(doubleEntryPoint.cryptoVault());
        forta.setDetectionBot(address(detectionBot));

        //////////////////////
        // LEVEL SUBMISSION //
        //////////////////////

        bool levelSuccessfullyPassed = ethernaut.submitLevelInstance(payable(_doubleEntryPoint));
        vm.stopPrank();
        assert(levelSuccessfullyPassed);
    }
}
