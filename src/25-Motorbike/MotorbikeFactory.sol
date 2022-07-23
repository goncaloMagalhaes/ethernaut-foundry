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
        // At least for now, in Foundry one cannot mine txs in the middle of a test, so the effects
        // of selfdestruct will only realize by the end of the test => this challenge cannot be tested
        // in Foundry. This may change --> https://github.com/foundry-rs/foundry/issues/1543
        // (bool success, ) = _instance.call(abi.encodeWithSignature("horsePower()"));
        return true;
    }

    receive() external payable {}
}