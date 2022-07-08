// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/3-CoinFlip/CoinFlipFactory.sol";
import "../src/3-CoinFlip/CoinFlipAttacker.sol";
import "../src/Ethernaut.sol";

contract CoinFlipTest is Test {
    Ethernaut ethernaut;
    address eoaAddress = address(100);

    function setUp() public {
        ethernaut = new Ethernaut();
        vm.deal(eoaAddress, 5 ether);
    }

    function testCoinFlipHack() public {
        // Level setup
        CoinFlipFactory coinFlipFactory = new CoinFlipFactory();
        ethernaut.registerLevel(coinFlipFactory);
        vm.startPrank(eoaAddress);
        address levelAddress = ethernaut.createLevelInstance(coinFlipFactory);
        CoinFlip ethernautCoinFlip = CoinFlip(payable(levelAddress));

        // Level attack
        CoinFlipAttacker attacker = new CoinFlipAttacker(levelAddress);
        for (uint i = 0; i < 10; i++) {
            vm.roll(2 + i);
            assertTrue(attacker.attack());
        }
        assertGe(ethernautCoinFlip.consecutiveWins(), 10);

        // Level submission
        bool levelSuccessfullyPassed = ethernaut.submitLevelInstance(payable(levelAddress)); 
        vm.stopPrank();
        assert(levelSuccessfullyPassed);
    }
}