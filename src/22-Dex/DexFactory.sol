// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "../Level.sol";
import "./Dex.sol";

contract DexFactory is Level {
    constructor() Owned(msg.sender) {}
    
    function createInstance(address _player) public payable override returns (address) {
        Dex instance = new Dex();
        SwappableToken token1 = new SwappableToken(address(instance), "Token1", "TK1", 1 ether);
        SwappableToken token2 = new SwappableToken(address(instance), "Token2", "TK2", 1 ether);
        instance.setTokens(address(token1), address(token2));
        
        // Transfer to dex
        token1.transfer(address(instance), 100);
        token2.transfer(address(instance), 100);
        
        // Transfer to player
        token1.transfer(_player, 10);
        token2.transfer(_player, 10);

        return address(instance);
    }

    function validateInstance(address payable _instance, address) override public returns (bool) {
        Dex dex = Dex(_instance);
        return dex.balanceOf(dex.token1(), _instance) == 0 || dex.balanceOf(dex.token2(), _instance) == 0;
    }

    receive() external payable {}
}