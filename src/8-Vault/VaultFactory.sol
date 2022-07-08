// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "../Level.sol";
import "./Vault.sol";

contract VaultFactory is Level {
    constructor() Owned(msg.sender) {}
    
    function createInstance(address _player) public payable override returns (address) {
        Vault instance = new Vault(keccak256("someRandomPassword"));
        return address(instance);
    }

    function validateInstance(address payable _instance, address _player) public view override returns (bool) {
        Vault instance = Vault(_instance);
        return !instance.locked();
    }
}