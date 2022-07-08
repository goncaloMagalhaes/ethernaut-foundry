// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "../Level.sol";
import "./Privacy.sol";

contract PrivacyFactory is Level {
    constructor() Owned(msg.sender) {}
    
    function createInstance(address _player) public payable override returns (address) {
        bytes32[3] memory data = [
            keccak256("someRandomPart1"),
            keccak256("someRandomPart2"),
            keccak256("someRandomPart3")
        ];
        Privacy instance = new Privacy(data);
        return address(instance);
    }

    function validateInstance(address payable _instance, address _player) override public returns (bool) {
        Privacy instance = Privacy(_instance);
        return !instance.locked();
    }

    receive() external payable {}
}