// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.20;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "forge-std/console.sol";

/// @title Escrow
/// @author Eric Abt
/// @notice Untrusted escrow. A buyer can put an arbitrary ERC20 token into a contract
// and a seller can withdraw it 3 days later.
contract Escrow {
    using SafeERC20 for IERC20;

    struct Deposit {
        address seller;
        address token;
        uint256 amount;
        uint256 timeStamp;
        bool paid;
    }

    mapping(uint256 => Deposit) deposits;

    function deposit(address _token, uint256 _amount, address _seller) external returns (uint256) {
        uint256 depositId = uint256(keccak256(abi.encode(block.timestamp, _token, _amount, msg.sender, _seller)));

        Deposit memory d = Deposit(_seller, _token, _amount, block.timestamp, false);

        IERC20 token = IERC20(_token);

        deposits[depositId] = d;

        token.safeTransfer(address(this), _amount);

        return depositId;
    }

    function withdraw(uint256 _depositId) external {
        Deposit memory d = deposits[_depositId];
        require(d.seller == msg.sender, "you are not the seller");
        require(d.paid == false, "already paid");
        require(block.timestamp - d.timeStamp >= 3 days, "Has not been 3 days");

        IERC20 token = IERC20(d.token);
        deposits[_depositId].paid = true;

        token.safeTransfer(d.seller, d.amount);
    }
}
