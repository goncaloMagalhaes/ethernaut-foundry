// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/26-DoubleEntryPoint/DoubleEntryPointFactory.sol";
import "../src/26-DoubleEntryPoint/DetectionBot.sol";
import "../src/Ethernaut.sol";

contract DoubleEntryPointTest is Test {
    Ethernaut ethernaut;
    address eoaAddress = address(100);

    function setUp() public {
        ethernaut = new Ethernaut();
        vm.deal(eoaAddress, 5 ether);
    }

    function testDoubleEntryPointHack() public {
        // Level setup
        DoubleEntryPointFactory doubleEntryPointFactory = new DoubleEntryPointFactory();
        ethernaut.registerLevel(doubleEntryPointFactory);
        vm.startPrank(eoaAddress);
        address levelAddress = ethernaut.createLevelInstance(doubleEntryPointFactory);
        DoubleEntryPoint ethernautDoubleEntryPoint = DoubleEntryPoint(payable(levelAddress));

        // Level attack
        address vault = ethernautDoubleEntryPoint.cryptoVault();
        DetectionBot bot = new DetectionBot(vault);

        Forta forta = ethernautDoubleEntryPoint.forta();
        forta.setDetectionBot(address(bot));
        
        // Level submission
        bool levelSuccessfullyPassed = ethernaut.submitLevelInstance(payable(levelAddress)); 
        vm.stopPrank();
        assert(levelSuccessfullyPassed);
    }
}