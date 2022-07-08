// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "../Level.sol";
import "./Elevator.sol";

contract ElevatorFactory is Level {
    constructor() Owned(msg.sender) {}
    
    function createInstance(address _player) public payable override returns (address) {
        Elevator instance = new Elevator();
        return address(instance);
    }

    function validateInstance(address payable _instance, address _player) override public returns (bool) {
        Elevator instance = Elevator(_instance);
        return instance.top();
    }

    receive() external payable {}
}