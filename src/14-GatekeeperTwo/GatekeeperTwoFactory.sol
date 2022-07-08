// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "../Level.sol";
import "./GatekeeperTwo.sol";

contract GatekeeperTwoFactory is Level {
    constructor() Owned(msg.sender) {}
    
    function createInstance(address _player) public payable override returns (address) {
        GatekeeperTwo instance = new GatekeeperTwo();
        return address(instance);
    }

    function validateInstance(address payable _instance, address _player) override public returns (bool) {
        GatekeeperTwo instance = GatekeeperTwo(_instance);
        return instance.entrant() == _player;
    }

    receive() external payable {}
}