// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/11-Elevator/ElevatorFactory.sol";
import "../src/11-Elevator/ElevatorAttacker.sol";
import "../src/Ethernaut.sol";

contract ElevatorTest is Test {
    Ethernaut ethernaut;
    address eoaAddress = address(100);

    function setUp() public {
        ethernaut = new Ethernaut();
        vm.deal(eoaAddress, 5 ether);
    }

    function testElevatorHack() public {
        // Level setup
        ElevatorFactory elevatorFactory = new ElevatorFactory();
        ethernaut.registerLevel(elevatorFactory);
        vm.startPrank(eoaAddress);
        address levelAddress = ethernaut.createLevelInstance(elevatorFactory);
        Elevator ethernautElevator = Elevator(payable(levelAddress));

        // Level attack
        ElevatorAttacker attacker = new ElevatorAttacker(levelAddress);
        attacker.attack();

        // Level submission
        bool levelSuccessfullyPassed = ethernaut.submitLevelInstance(payable(levelAddress)); 
        vm.stopPrank();
        assert(levelSuccessfullyPassed);
    }
}