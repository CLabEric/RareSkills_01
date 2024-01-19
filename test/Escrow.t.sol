// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {Test, console} from "forge-std/Test.sol";
import {Escrow} from "../src/Escrow.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract EscrowTest is Test {
    address constant WETH_ADDRESS = address(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2);
    address internal buyer = address(0x8EB8a3b98659Cce290402893d0123abb75E3ab28);
    address internal seller;

    Escrow public escrow;

    IERC20 weth = IERC20(WETH_ADDRESS);

    function setUp() public {
        seller = address(2);

        vm.label(buyer, "Buyer");
        vm.label(seller, "Seller");

        escrow = new Escrow();
    }

    function testDeposit() public {
        vm.prank(buyer);
        escrow.deposit(WETH_ADDRESS, 100, seller);

        assertEq(weth.balanceOf(address(escrow)), 100);
    }

    function testWithdraw() public {
        vm.prank(buyer);
        uint256 depositId = escrow.deposit(WETH_ADDRESS, 100, seller);

        skip(3 days);
        vm.prank(seller);
        escrow.withdraw(depositId);

        assertEq(weth.balanceOf(seller), 100);
    }
}
