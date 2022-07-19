// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "../Level.sol";
import "./MagicNum.sol";

interface ISolver {
    function whatIsTheMeaningOfLife() external returns (bytes32);
}

contract MagicNumFactory is Level {
    constructor() Owned(msg.sender) {}
    
    function createInstance(address _player) public payable override returns (address) {
        MagicNum instance = new MagicNum();
        return address(instance);
    }

    function validateInstance(address payable _instance, address _player) override public returns (bool) {
        address solver = MagicNum(_instance).solver();
        uint size;
        assembly {
            size := extcodesize(solver)
        }
        return size <= 10 && uint256(ISolver(solver).whatIsTheMeaningOfLife()) == 42;
    }

    receive() external payable {}
}