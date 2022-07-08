// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "../Level.sol";
import "./Reentrance.sol";

contract ReentranceFactory is Level {
    uint initialValue = 1 ether;
    address someDonationAddress = address(1);

    constructor() Owned(msg.sender) {}
    
    function createInstance(address _player) public payable override returns (address) {
        require(msg.value >= initialValue);
        Reentrance instance = new Reentrance();
        instance.donate{value: msg.value}(someDonationAddress);
        return address(instance);
    }

    function validateInstance(address payable _instance, address _player) override public returns (bool) {
        Reentrance instance = Reentrance(_instance);
        return address(instance).balance == 0;
    }

    receive() external payable {}
}