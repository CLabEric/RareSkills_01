// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {Test, console} from "forge-std/Test.sol";
import {Escrow} from "../src/Escrow.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract EscrowTest is Test {
    address constant WETH_ADDRESS = address(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2);
    address constant RANDOM_WHALE = address(0x8EB8a3b98659Cce290402893d0123abb75E3ab28);

    Escrow public escrow;

    address internal buyer;
    address internal seller;

    IERC20 weth = IERC20(WETH_ADDRESS);

    function setUp() public {
        buyer = address(1);
        seller = address(2);

        vm.label(buyer, "Buyer");
        vm.label(seller, "Seller");

        escrow = new Escrow();
    }

    function testDeposit() public {
        vm.prank(RANDOM_WHALE);

        // address receiver = vm.addr(1);

        bytes32 depositId = escrow.deposit(WETH_ADDRESS, 100, seller);
        console.log("depositId", depositId);
        // assertEq(weth.balanceOf( address(vesting) ), 100);
    }

    function testWithdraw() public {}
}
