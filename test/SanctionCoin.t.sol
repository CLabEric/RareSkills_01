// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {Test, console} from "forge-std/Test.sol";
import {SanctionCoin} from "../src/SanctionCoin.sol";

contract SanctionCoinTest is Test {

    SanctionCoin public sanctionCoin;

    address internal owner;
    address internal user1;
    address internal user2;

    function setUp() public {
        owner = address(this);
        user1 = address(1);
        user2 = address(2);

        vm.label(owner, "Owner");
        vm.label(user1, "User1");
        vm.label(user2, "User2");

        sanctionCoin = new SanctionCoin();
    }

    function testMint() public {
        assertEq(sanctionCoin.balanceOf(user1), 0);
        vm.prank(user1);
        sanctionCoin.mint(5);
        assertEq(sanctionCoin.balanceOf(user1), 5);
    }

    function testSetSanction() public {
        sanctionCoin.setSanction(user1);
        vm.prank(user1);
        
        vm.expectRevert("User not allowed to send/receive tokens");
        sanctionCoin.mint(5);
    }

//     function testFuzz_SetNumber(uint256 x) public {
//         counter.setNumber(x);
//         assertEq(counter.number(), x);
//     }
}


// Insurance claims
// Book snow day
// 100 hands - email sent