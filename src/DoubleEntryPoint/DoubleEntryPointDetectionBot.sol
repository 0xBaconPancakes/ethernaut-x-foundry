// SPDX-License-Identifier: MIT

pragma solidity ^0.8.10;


import "ds-test/test.sol";
import "./DoubleEntryPoint.sol";

contract DoubleEntryPointDetectionBot is IDetectionBot, DSTest {
    address public vault;
    bytes4 private constant DELEGATE_TRANSFER_SELECTOR = 0x9cd1a121;

    constructor(address _vault) {
        require(bytes4(keccak256("delegateTransfer(address,uint256,address)")) == DELEGATE_TRANSFER_SELECTOR, "Wrong selector.");
        vault = _vault;
    }

    function handleTransaction(address user, bytes calldata msgData) external override {
        bytes4 selector;
        assembly {
            selector := calldataload(msgData.offset)
        }

        /*
        * function delegateTransfer(address to,uint256 value,address origSender)
        * 4 bytes selector
        * 32 bytes address to           -> 4 bytes offset
        * 32 bytes uint256 value        -> 36 bytes offset
        * 32 bytes address origSender   -> 68 bytes offset
        */

        if (selector == DELEGATE_TRANSFER_SELECTOR) {
            address to;
            uint256 value;
            address origSender;
            assembly {
                to := calldataload(add(msgData.offset, 4))
                value := calldataload(add(msgData.offset, 36))
                origSender := calldataload(add(msgData.offset, 68))
            }
            if (origSender == vault) {
                Forta(msg.sender).raiseAlert(user);
            }
        }
    }
}