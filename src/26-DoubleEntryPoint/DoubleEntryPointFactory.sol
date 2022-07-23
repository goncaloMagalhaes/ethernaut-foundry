// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "../Level.sol";
import "./DoubleEntryPoint.sol";

contract DoubleEntryPointFactory is Level {
    address sweptTokensRecipient = address(999999); 
    constructor() Owned(msg.sender) {}
    
    function createInstance(address _player) public payable override returns (address) {
        LegacyToken legacyToken = new LegacyToken();
        CryptoVault vault = new CryptoVault(sweptTokensRecipient);
        Forta forta = new Forta();
        
        DoubleEntryPoint instance = new DoubleEntryPoint(
            address(legacyToken),
            address(vault),
            address(forta),
            _player
        );
        vault.setUnderlying(address(instance));
        legacyToken.mint(address(vault), 100);

        legacyToken.delegateToNewContract(instance);

        return address(instance);
    }

    function validateInstance(address payable _instance, address) override public returns (bool) {
        DoubleEntryPoint det = DoubleEntryPoint(_instance);
        address delegated = det.delegatedFrom();
        address vault = det.cryptoVault();

        try CryptoVault(vault).sweepToken(IERC20(delegated)) {
            return false;
        } catch {
            return true;
        }
    }

    receive() external payable {}
}