// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/10-Reentrancy/ReentranceFactory.sol";
import "../src/10-Reentrancy/ReentranceAttacker.sol";
import "../src/Ethernaut.sol";

contract ReentranceTest is Test {
    Ethernaut ethernaut;
    address eoaAddress = address(100);

    function setUp() public {
        ethernaut = new Ethernaut();
        vm.deal(eoaAddress, 5 ether);
    }

    function testReentranceHack() public {
        // Level setup
        ReentranceFactory reentranceFactory = new ReentranceFactory();
        ethernaut.registerLevel(reentranceFactory);
        vm.startPrank(eoaAddress);
        address levelAddress = ethernaut.createLevelInstance{value: 1_500_000_000 gwei}(reentranceFactory);  // 1.5 ether
        Reentrance ethernautReentrance = Reentrance(payable(levelAddress));

        // Level attack
        ReentranceAttacker attacker = new ReentranceAttacker(levelAddress);
        bool success = attacker.attack{value: 1 ether}();
        assertTrue(success);

        // Level submission
        bool levelSuccessfullyPassed = ethernaut.submitLevelInstance(payable(levelAddress)); 
        vm.stopPrank();
        assert(levelSuccessfullyPassed);
    }
}