// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "../Level.sol";
import "./Token.sol";

contract TokenFactory is Level {
    uint public constant SUPPLY = 21000000;
    uint public constant PLAYER_SUPPLY = 20;

    constructor() Owned(msg.sender) {}
    
    function createInstance(address _player) public payable override returns (address) {
        Token instance = new Token(SUPPLY);
        instance.transfer(_player, PLAYER_SUPPLY);
        return address(instance);
    }

    function validateInstance(address payable _instance, address _player) public view override returns (bool) {
        Token instance = Token(_instance);
        return instance.balanceOf(_player) > PLAYER_SUPPLY;
    }
}