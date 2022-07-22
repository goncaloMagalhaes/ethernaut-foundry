// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "forge-std/Test.sol";

contract MyContractWithEvent {
    event Event(string value);

    function emitEvent(string calldata value) external {
        emit Event(value);
    } 
}

contract MyContractWithIndexedEvent {
    event Event(string indexed value);

    function emitEvent(string calldata value) external {
        emit Event(value);
    } 
}

contract MyTest is Test {
    address eoaAddress = address(100);

    function setUp() public {
        vm.deal(eoaAddress, 5 ether);
    }

    function testIndex() public {
        vm.startPrank(eoaAddress);
        
        MyContractWithEvent c1 = new MyContractWithEvent();
        MyContractWithIndexedEvent c2 = new MyContractWithIndexedEvent();

        c1.emitEvent("I'm passing a large string with a length much greater than 32bytes");
        c2.emitEvent("I'm passing a large string with a length much greater than 32bytes");

        vm.stopPrank();
    }
}