// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "../Level.sol";
import "./King.sol";

contract KingFactory is Level {
    constructor() Owned(msg.sender) {}
    
    function createInstance(address _player) public payable override returns (address) {
        require(msg.value > 0);
        King instance = new King{value: msg.value}();
        return address(instance);
    }

    function validateInstance(address payable _instance, address _player) override public returns (bool) {
        King instance = King(_instance);
        (bool success, ) = address(instance).call{value: 0}("");
        return instance._king() != address(this);
    }

    receive() external payable {}
}