// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "./DoubleEntryPoint.sol";

contract DetectionBot {
    address public vault;

    constructor(address _vault) {
        vault = _vault;
    }

    function handleTransaction(address user, bytes calldata msgData) external {
        // Calldata is composed by funcSignature and parameters
        // msgData is calldata of delegateTransfer
        // - funcSignature (4bytes) -> bytes4(abi.encode("delegateTransfer(address,uint256,address)"))
        // - delegateTransfer parameters -> address to, uint256 value, address origSender -> 
        //   -> 20bytes, 32bytes, 20bytes ---> 32bytes, 32bytes, 32bytes (padded)
        // Full calldata:
        // - funcSignature (4bytes) -> bytes4(abi.encode("handleTransaction(address,bytes)"))
        // - parameters -> address user, bytes calldata msgData --> 
        //   -> 32bytes, msgData
        // According to https://docs.soliditylang.org/en/v0.8.15/abi-spec.html, a bytes argument
        // encodes with some stuff: 
        // - 32bytes for location of data part measured in bytes from the start of the arguments block
        // - 32bytes with length
        // - data
        // All in all:
        // funcSig(4B)+user(32B)+(64B)+delegateFuncSig(4B)+to(32B)+value(32B)+origSender(32B)+padding
        // origSender --> 4+32+64+4+32+32 = 168 -> 0xa8
        address origSender;
        assembly {
            origSender := calldataload(0xa8)
        }
        if (origSender == vault) {
            Forta(msg.sender).raiseAlert(user);
        }
    }
}
