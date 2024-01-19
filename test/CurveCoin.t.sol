// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {Test, console} from "forge-std/Test.sol";
import {CurveCoin} from "../src/CurveCoin.sol";

contract CurveCoinTest is Test {
    CurveCoin public curveCoin;

    address internal user;

    function setUp() public {
        user = address(1);

        vm.label(user, "User");

        curveCoin = new CurveCoin();
    }

    function testGetTotalCost() public {
        uint256 total = (5 * 6) / 2;

        assertEq(curveCoin.getTotalCost(5), total);
    }

    function testMint() public {
        assertEq(curveCoin.balanceOf(user), 0);
        vm.prank(user);
        vm.deal(user, 100 ether);

        uint256 total = (5 * 6) / 2;
        curveCoin.mint{value: total * 1 ether}(5);

        assertEq(curveCoin.balanceOf(user), 5);
    }

    function testGetTotalBuyback() public {
        vm.prank(user);
        vm.deal(user, 15 ether);

        uint256 total = (5 * 6) / 2;
        curveCoin.mint{value: total * 1 ether}(5);

        uint256 totalBuyBack = curveCoin.getTotalBuyBack(5);

        assertEq(totalBuyBack, total);
    }

    function testBurn() public {
        vm.prank(user);
        vm.deal(user, 15 ether);

        uint256 total = (5 * 6) / 2;
        curveCoin.mint{value: total * 1 ether}(5);

        uint256 amount = curveCoin.balanceOf(user);
        vm.prank(user);
        curveCoin.buyBack(amount);
        assertEq(curveCoin.balanceOf(user), 0);
    }
}
