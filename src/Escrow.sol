// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.20;

// Untrusted escrow. Create a contract where a buyer can put an arbitrary ERC20 token 
// into a contract and a seller can withdraw it 3 days later. Based on your readings 
// above, what issues do you need to defend against? Create the safest version of 
// this that you can while guarding against issues that you cannot control. Does your 
// contract handle fee-on transfer tokens or non-standard ERC20 tokens.


import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Escrow {

    struct Deposit {
        address seller;
        address token;
        bytes32 id;
        uint256 amount;
        uint256 timeStamp;
        bool paid;
    }

    mapping(bytes32 => Deposit) deposits;

    function deposit(address _token, uint256 _amount, address _seller) external returns (bytes32) {
        bytes32 depositId = keccak256(abi.encode(block.timestamp, _token, _amount, msg.sender, _seller));

        Deposit memory d = Deposit(_seller, _token, depositId, _amount, block.timestamp, false);

        IERC20 token = IERC20(_token);

        deposits[depositId] = d;

        token.transfer(address(this), _amount);

        return depositId;
    }

    function withdraw(bytes32 _depositId) external {
        Deposit memory d = deposits[_depositId];
        require(block.timestamp - d.timeStamp >= 3 days, "Has not been 3 days");

        IERC20 token = IERC20(d.token);
        deposits[_depositId].paid = true;

        token.transfer(d.seller, d.amount);
    }
}