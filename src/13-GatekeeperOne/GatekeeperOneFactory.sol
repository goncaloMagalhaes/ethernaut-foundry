// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "../Level.sol";
import "./GatekeeperOne.sol";

contract GatekeeperOneFactory is Level {
    constructor() Owned(msg.sender) {}
    
    function createInstance(address _player) public payable override returns (address) {
        GatekeeperOne instance = new GatekeeperOne();
        return address(instance);
    }

    function validateInstance(address payable _instance, address _player) override public returns (bool) {
        GatekeeperOne instance = GatekeeperOne(_instance);
        return instance.entrant() == _player;
    }

    receive() external payable {}
}