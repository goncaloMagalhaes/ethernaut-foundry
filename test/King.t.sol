// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/9-King/KingFactory.sol";
import "../src/9-King/KingAttacker.sol";
import "../src/Ethernaut.sol";

contract KingTest is Test {
    Ethernaut ethernaut;
    address eoaAddress = address(100);

    function setUp() public {
        ethernaut = new Ethernaut();
        vm.deal(eoaAddress, 5 ether);
    }

    function testKingHack() public {
        // Level setup
        KingFactory kingFactory = new KingFactory();
        ethernaut.registerLevel(kingFactory);
        vm.startPrank(eoaAddress);
        address levelAddress = ethernaut.createLevelInstance{value: 1 ether}(kingFactory);
        King ethernautKing = King(payable(levelAddress));

        // Level attack
        KingAttacker attacker = new KingAttacker(levelAddress);
        bool success = attacker.attack{value: 2 ether}();
        assertTrue(success);

        // Level submission
        bool levelSuccessfullyPassed = ethernaut.submitLevelInstance(payable(levelAddress)); 
        vm.stopPrank();
        assert(levelSuccessfullyPassed);
    }
}