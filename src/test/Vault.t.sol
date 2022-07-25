// SPDX-License-Identifier: MIT

pragma solidity ^0.8.10;

import "ds-test/test.sol";
import "../Vault/Vault.sol";
import "../Vault/VaultFactory.sol";
import "../Ethernaut.sol";
import "./utils/vm.sol";

contract VaultTest is DSTest {
    Vm vm = Vm(address(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D));
    Ethernaut ethernaut;

    function setUp() public {
        // Setup instance of the Ethernaut contracts
        ethernaut = new Ethernaut();
    }

    function testVaultAttack() public {
        /////////////////
        // LEVEL SETUP //
        /////////////////

        VaultFactory vaultFactory = new VaultFactory();
        ethernaut.registerLevel(vaultFactory);
        vm.startPrank(tx.origin);
        address levelAddress = ethernaut.createLevelInstance(vaultFactory);

        //////////////////
        // LEVEL ATTACK //
        //////////////////

        Vault vault = Vault(levelAddress);

        // Use cheats to get the 'private' memory slot, which is always visible
        bytes32 password = vm.load(levelAddress, bytes32(uint256(1)));

        emit log_named_bytes32("Vault password:", password);

        vault.unlock(password);
        
        //////////////////////
        // LEVEL SUBMISSION //
        //////////////////////

        bool levelSuccessfullyPassed = ethernaut.submitLevelInstance(payable(levelAddress));
        vm.stopPrank();
        assert(levelSuccessfullyPassed);
    }
}