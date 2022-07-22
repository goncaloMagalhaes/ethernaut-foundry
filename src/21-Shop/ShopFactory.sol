// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "../Level.sol";
import "./Shop.sol";

contract ShopFactory is Level {
    uint public initialPrice;

    constructor() Owned(msg.sender) {}
    
    function createInstance(address) public payable override returns (address) {
        Shop instance = new Shop();
        initialPrice = instance.price();
        return address(instance);
    }

    function validateInstance(address payable _instance, address) override public returns (bool) {
        Shop shop = Shop(_instance);
        return shop.isSold() && shop.price() < initialPrice;
    }

    receive() external payable {}
}