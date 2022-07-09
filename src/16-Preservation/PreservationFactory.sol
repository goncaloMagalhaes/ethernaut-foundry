// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "../Level.sol";
import "./Preservation.sol";

contract PreservationFactory is Level {
    constructor() Owned(msg.sender) {}
    
    function createInstance(address _player) public payable override returns (address) {
        LibraryContract library1 = new LibraryContract();
        LibraryContract library2 = new LibraryContract();
        Preservation instance = new Preservation(address(library1), address(library2));
        return address(instance);
    }

    function validateInstance(address payable _instance, address _player) override public returns (bool) {
        Preservation instance = Preservation(_instance);
        return instance.owner() == _player;
    }

    receive() external payable {}
}