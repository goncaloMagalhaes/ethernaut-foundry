// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "solmate/auth/Owned.sol";

abstract contract Level is Owned {
    function createInstance(address _player) virtual public payable returns (address);
    function validateInstance(address payable _instance, address _player) virtual public returns (bool);
}
