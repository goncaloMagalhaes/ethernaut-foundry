// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "../Level.sol";
import "./Delegation.sol";

contract DelegationFactory is Level {
    uint public constant SUPPLY = 21000000;
    uint public constant PLAYER_SUPPLY = 20;

    constructor() Owned(msg.sender) {}
    
    function createInstance(address _player) public payable override returns (address) {
        Delegate delegate = new Delegate(address(1));
        Delegation instance = new Delegation(address(delegate));
        return address(instance);
    }

    function validateInstance(address payable _instance, address _player) public view override returns (bool) {
        Delegation instance = Delegation(_instance);
        return instance.owner() == _player;
    }
}