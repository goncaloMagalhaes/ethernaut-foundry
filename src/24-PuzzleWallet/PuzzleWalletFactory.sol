// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "../Level.sol";
import "./PuzzleWallet.sol";

contract PuzzleWalletFactory is Level {

    address adminAddress = address(999_999 ether);

    constructor() Owned(msg.sender) {}
    
    function createInstance(address) public payable override returns (address) {
        require(msg.value >= 2 ether, "not enough ether");
        PuzzleWallet wallet = new PuzzleWallet();
        PuzzleProxy instance = new PuzzleProxy(
            adminAddress,
            address(wallet),
            abi.encodeWithSignature("init(uint256)", 10 ether)
        );

        (bool successWhitelist1, ) = address(instance).call(abi.encodeWithSignature("addToWhitelist(address)", address(1)));
        (bool successWhitelist2, ) = address(instance).call(abi.encodeWithSignature("addToWhitelist(address)", address(this)));
        (bool successCall, ) = address(instance).call{value: 2 ether}(abi.encodeWithSignature("deposit()"));
        require(successWhitelist1);
        require(successWhitelist2);
        require(successCall);

        return address(instance);
    }

    function validateInstance(address payable _instance, address _player) override public returns (bool) {
        PuzzleProxy proxy = PuzzleProxy(_instance);
        return proxy.admin() == _player;
    }

    receive() external payable {}
}