// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "./Level.sol";
import "solmate/auth/Owned.sol";

contract Ethernaut is Owned {
    mapping(address => bool) public registeredLevels;

    struct EmittedInstanceData {
        address player;
        Level level;
        bool completed;
    }

    mapping(address => EmittedInstanceData) emittedInstances;

    event LevelInstanceCreatedLog(address indexed player, address instance);
    event LevelCompletedLog(address indexed player, Level level);

    constructor() Owned(msg.sender) {}

    function registerLevel(Level _level) public onlyOwner {
        registeredLevels[address(_level)] = true;
    }

    function createLevelInstance(Level _level) public payable returns (address) {
        require(registeredLevels[address(_level)], "Level not registered");

        address instance = _level.createInstance{value: msg.value}(msg.sender);
        emittedInstances[instance] = EmittedInstanceData(msg.sender, _level, false);

        emit LevelInstanceCreatedLog(msg.sender, instance);
        return instance;
    }

    function submitLevelInstance(address payable _instance) public returns (bool) {
        EmittedInstanceData storage data = emittedInstances[_instance];
        require(data.player == msg.sender, "Wrong instance for player");
        require(data.completed == false, "Level completed already");

        if(data.level.validateInstance(_instance, msg.sender)) {
            // level completed
            data.completed = true;
            emit LevelCompletedLog(msg.sender, data.level);
            return true;
        }

        return false;
    }
}