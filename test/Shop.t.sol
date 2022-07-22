// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/21-Shop/ShopFactory.sol";
import "../src/21-Shop/ShopAttacker.sol";
import "../src/Ethernaut.sol";

contract ShopTest is Test {
    Ethernaut ethernaut;
    address eoaAddress = address(100);

    function setUp() public {
        ethernaut = new Ethernaut();
        vm.deal(eoaAddress, 5 ether);
    }

    function testShopHack() public {
        // Level setup
        ShopFactory shopFactory = new ShopFactory();
        ethernaut.registerLevel(shopFactory);
        vm.startPrank(eoaAddress);
        address levelAddress = ethernaut.createLevelInstance{value: 1 ether}(shopFactory);
        Shop ethernautShop = Shop(payable(levelAddress));

        // Level attack
        ShopAttacker attacker = new ShopAttacker(address(ethernautShop));
        attacker.attack();

        // Level submission
        bool levelSuccessfullyPassed = ethernaut.submitLevelInstance(payable(levelAddress)); 
        vm.stopPrank();
        assert(levelSuccessfullyPassed);
    }
}