// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "../Level.sol";
import "./CoinFlip.sol";

contract CoinFlipFactory is Level {
    constructor() Owned(msg.sender) {}
    
    function createInstance(address _player) public payable override returns (address) {
        CoinFlip instance = new CoinFlip();
        return address(instance);
    }

    function validateInstance(address payable _instance, address _player) public view override returns (bool) {
        CoinFlip instance = CoinFlip(_instance);
        return instance.consecutiveWins() >= 10;
    }
}