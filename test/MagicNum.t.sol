// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/18-MagicNumber/MagicNumFactory.sol";
import "../src/Ethernaut.sol";

contract MagicNumTest is Test {
    Ethernaut ethernaut;
    address eoaAddress = address(100);

    function setUp() public {
        ethernaut = new Ethernaut();
        vm.deal(eoaAddress, 5 ether);
    }

    function testMagicNumHack() public {
        // Level setup
        MagicNumFactory magicNumFactory = new MagicNumFactory();
        ethernaut.registerLevel(magicNumFactory);
        vm.startPrank(eoaAddress);
        address levelAddress = ethernaut.createLevelInstance(magicNumFactory);
        MagicNum ethernautMagicNum = MagicNum(payable(levelAddress));

        // Level attack
        // RUNTIME CODE
        // PUSH1 0x2a  -->  push 42 into stack (magic number)                               -->  602a
        // PUSH1 0x40  -->  push 0x40 into stack (place to put in memory)                   -->  6040
        // MSTORE      -->  store 2a in position 40                                         -->  52
        // PUSH1 0x20  -->  store 0x20 as length of value to return from memory (32bytes)   -->  6020
        // PUSH1 0x40  -->  store 0x40 as the place where our value is stored in memory     -->  6040
        // RETURN      -->  return that value (0x2a --> number 42)                          -->  f3
        // Final compiled runtime code ----> 602a60405260326040f3 ----> 10bytes
        // --
        // INIT CODE (returns the runtime code to the EVM) --> https://monokh.com/posts/ethereum-contract-creation-bytecode
        // PUSH1 0x0a  --> push contract length to stack (0x0a is 10)                  -->  600a
        // DUP1        --> duplicates 0x0a to stack again                              -->  80
        // PUSH1 0x0b  --> push PC of runtime code to stack (11 bytes of init code)    -->  600b
        // PUSH1 0x80  --> push 0x80 to stack (place to put in memory, cause why not)  -->  6080
        // CODECOPY    --> copies code running in current environment to memory        -->  39
        // PUSH1 0x80  --> pushes place of runtime code in memory                      -->  6080
        // RETURN      --> return the value in memory                                  -->  f3
        // Final compiled init code ----> 600a80600b6080396080f3
        // --
        // Final code --> 600a80600b6080396080f3602a60405260206040f43
        bytes memory code = "\x60\x0a\x80\x60\x0b\x60\x80\x39\x60\x80\xf3\x60\x2a\x60\x40\x52\x60\x20\x60\x40\xf3";
        address solver;
        assembly {
            solver := create(0, add(code, 0x20), mload(code))  // create(weiValue, memOffset, length)
            if iszero(extcodesize(solver)) {
                revert(0, 0)
            }
        }

        emit log_named_address("Solver", solver);
        ethernautMagicNum.setSolver(solver);

        // Level submission
        bool levelSuccessfullyPassed = ethernaut.submitLevelInstance(payable(levelAddress)); 
        vm.stopPrank();
        assert(levelSuccessfullyPassed);
    }
}