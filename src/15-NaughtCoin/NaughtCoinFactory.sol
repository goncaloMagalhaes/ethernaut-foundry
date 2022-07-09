// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "../Level.sol";
import "./NaughtCoin.sol";

contract NaughtCoinFactory is Level {
    constructor() Owned(msg.sender) {}
    
    function createInstance(address _player) public payable override returns (address) {
        NaughtCoin instance = new NaughtCoin(_player);
        return address(instance);
    }

    function validateInstance(address payable _instance, address _player) override public returns (bool) {
        NaughtCoin instance = NaughtCoin(_instance);
        return instance.balanceOf(_player) == 0;
    }

    receive() external payable {}
}