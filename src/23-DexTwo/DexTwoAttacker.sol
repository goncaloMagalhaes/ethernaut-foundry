// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "solmate/tokens/ERC20.sol";

contract DexTwoAttacker is ERC20 {
    constructor() ERC20("AttackerToken", "ATK", 18) {
        _mint(msg.sender, 1_000_000 ether);
    }
}
