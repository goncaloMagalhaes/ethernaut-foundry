// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/4-Telephone/TelephoneFactory.sol";
import "../src/4-Telephone/TelephoneAttacker.sol";
import "../src/Ethernaut.sol";

contract TelephoneTest is Test {
    Ethernaut ethernaut;

    function setUp() public {
        ethernaut = new Ethernaut();
    }

    function testTelephoneHack() public {
        // Level setup
        TelephoneFactory telephoneFactory = new TelephoneFactory();
        ethernaut.registerLevel(telephoneFactory);
        vm.startPrank(tx.origin);
        address levelAddress = ethernaut.createLevelInstance(telephoneFactory);
        Telephone ethernautTelephone = Telephone(payable(levelAddress));

        // Level attack
        TelephoneAttacker attacker = new TelephoneAttacker(levelAddress);
        attacker.attack();

        // Level submission
        bool levelSuccessfullyPassed = ethernaut.submitLevelInstance(payable(levelAddress)); 
        vm.stopPrank();
        assert(levelSuccessfullyPassed);
    }
}