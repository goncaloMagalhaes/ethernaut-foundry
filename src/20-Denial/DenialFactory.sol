// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "../Level.sol";
import "./Denial.sol";

contract DenialFactory is Level {
    constructor() Owned(msg.sender) {}
    
    function createInstance(address) public payable override returns (address) {
        require(msg.value >= 1 ether, "Not enough ether");  // cause why not
        Denial instance = new Denial();
        (bool success, ) = address(instance).call{value: msg.value}("");
        require(success);
        return address(instance);
    }

    function validateInstance(address payable _instance, address) override public returns (bool) {
        require(Denial(_instance).contractBalance() > 100 wei, "No sufficient money in contract");
        (bool success, ) = _instance.call{gas: 1_000_000}(abi.encodeWithSignature("withdraw()"));
        return !success;
    }

    receive() external payable {}
}