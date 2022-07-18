// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "../Level.sol";
import "./Recovery.sol";

contract RecoveryFactory is Level {
    constructor() Owned(msg.sender) {}
    
    function createInstance(address _player) public payable override returns (address) {
        require(msg.value >= 0.001 ether, "Not enough ether");
        Recovery instance = new Recovery();
        instance.generateToken("SimpleToken", 1 ether);
        address token = computeLostAddress(address(instance));
        (bool success, ) = token.call{value: 0.001 ether}("");
        require(success);
        return address(instance);
    }

    function validateInstance(address payable _instance, address _player) override public returns (bool) {
        address tokenLost = computeLostAddress(_instance);
        return tokenLost.balance == 0;
    }

    function computeLostAddress(address _instance) pure public returns (address lostAddress) {
        // Address of created contract depends on sender address and sender nonce
        // address = least_significant_20bytes(keccak256(RLP(sender, nonce)))
        // -- RLP of sender:
        //     - address is bytes20, meaning RLP is (0x80 + length) + sender
        //     - 0x80 + 20, sender
        //     - 0x94, sender (sender is instance address) --> 21bytes
        // -- RLP of nonce:
        //     - nonce is a single byte, it's just its value: RLP(nonce) = nonce
        //     - nonce = 0x01 (first contract creation, EIP-161 makes nonce increment prior to creation)
        // -- RLP of RLP(sender), RLP(nonce):
        //     - (RLP(sender), RLP(nonce)) is RLP of list, with bytes22, so (0xc0 + length) + RLPs
        //     - 0xc0 + 22, RLP
        //     - 0xd6, RLP
        //     - 0xd6, 0x94, sender, 0x01
        // For more on RLP --> https://ethereum.org/en/developers/docs/data-structures-and-encoding/rlp/
        lostAddress = address(uint160(uint256(keccak256(abi.encodePacked(
            bytes1(0xd6),
            bytes1(0x94),
            _instance,
            bytes1(0x01)
        )))));
    }

    receive() external payable {}
}