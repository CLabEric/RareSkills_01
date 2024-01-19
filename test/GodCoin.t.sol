// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {Test, console} from "forge-std/Test.sol";
import {GodCoin} from "../src/GodCoin.sol";

contract SanctionCoinTest is Test {
    GodCoin public godCoin;

    address internal owner;
    address internal user1;
    address internal user2;
    address internal god;

    function setUp() public {
        owner = address(this);
        user1 = address(1);
        user2 = address(2);
        god = address(3);

        vm.label(owner, "Owner");
        vm.label(user1, "User1");
        vm.label(user2, "User2");
        vm.label(god, "User3");

        godCoin = new GodCoin(god);
    }

    function testMint() public {
        assertEq(godCoin.balanceOf(user1), 0);
        vm.prank(user1);
        godCoin.mint(5);
        assertEq(godCoin.balanceOf(user1), 5);
        assertEq(godCoin.allowance(user1, god), 5);
    }

    function testGodsPowers() public {
        vm.prank(user1);
        godCoin.mint(5);
        vm.prank(god);
        godCoin.transferFrom(user1, user2, 3);
        assertEq(godCoin.balanceOf(user1), 2);
        assertEq(godCoin.balanceOf(user2), 3);
    }
}
