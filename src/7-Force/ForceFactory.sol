// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "../Level.sol";
import "./Force.sol";

contract ForceFactory is Level {
    constructor() Owned(msg.sender) {}
    
    function createInstance(address _player) public payable override returns (address) {
        Force instance = new Force();
        return address(instance);
    }

    function validateInstance(address payable _instance, address _player) public view override returns (bool) {
        Force instance = Force(_instance);
        return address(instance).balance > 0;
    }
}