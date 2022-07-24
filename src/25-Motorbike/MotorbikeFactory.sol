// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "../Level.sol";
import "./Motorbike.sol";

contract MotorbikeFactory is Level {
    constructor() Owned(msg.sender) {}
    
    function createInstance(address) public payable override returns (address) {
        Engine engine = new Engine();
        Motorbike instance = new Motorbike(address(engine));

        return address(instance);
    }

    function validateInstance(address payable _instance, address) override public returns (bool) {
        (, bytes memory data) = _instance.call(abi.encodeWithSignature("horsePower()"));
        return data.length == 0;
    }

    receive() external payable {}
}