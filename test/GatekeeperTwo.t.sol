// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/14-GatekeeperTwo/GatekeeperTwoFactory.sol";
import "../src/14-GatekeeperTwo/GatekeeperTwoAttacker.sol";
import "../src/Ethernaut.sol";

contract GatekeeperTwoTest is Test {
    Ethernaut ethernaut;

    function setUp() public {
        ethernaut = new Ethernaut();
        vm.deal(tx.origin, 5 ether);
    }

    function testGatekeeperTwoHack() public {
        // Level setup
        GatekeeperTwoFactory gatekeeperTwoFactory = new GatekeeperTwoFactory();
        ethernaut.registerLevel(gatekeeperTwoFactory);
        vm.startPrank(tx.origin);
        address levelAddress = ethernaut.createLevelInstance(gatekeeperTwoFactory);
        GatekeeperTwo ethernautGatekeeperTwo = GatekeeperTwo(payable(levelAddress));

        // Level attack
        bytes8 key = bytes8(0);
        emit log_named_bytes32("Key", bytes32(key));
        GatekeeperTwoAttacker attacker = new GatekeeperTwoAttacker(levelAddress);

        // Level submission
        bool levelSuccessfullyPassed = ethernaut.submitLevelInstance(payable(levelAddress)); 
        vm.stopPrank();
        assert(levelSuccessfullyPassed);
    }
}