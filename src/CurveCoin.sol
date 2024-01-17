// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.20;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";


// - [ ]  Token sale and buyback with bonding curve. The more tokens a user buys, the 
// more expensive the token becomes. To keep things simple, use a linear bonding curve.
// - [ ]  Consider the case someone might [sandwhich attack]
// (https://medium.com/coinmonks/defi-sandwich-attack-explain-776f6f43b2fd) a 
// bonding curve. What can you do about it?
contract CurveCoin is ERC20("Curve Coin", "CC") {

    /// @notice A user can mint any amount of this token
    /// @dev price will update according to a bond curve
    /// @param _amount uint256 - number of tokens to mint
    function mint(uint256 _amount) external payable {
        uint256 totalCost = getTotalCost(_amount);

        require(totalCost <= msg.value, "not enough ether sent");

        _mint(msg.sender, _amount);
    }

    function buyBack(uint256 _amount) external {
        require(_amount <= balanceOf(msg.sender), "too big of an amount");

        uint256 buyBackAmount = getTotalBuyBack(_amount);

        _burn(address(this), _amount);

        (bool sent, ) = payable(msg.sender).call{value: buyBackAmount}("");
        require(sent, "transfer failed");
    }

    /// @dev get total amount according to linear curve
    /// @param _amount uint256 - number of tokens to mint
    function getTotalCost(uint256 _amount) internal view returns (uint256 totalCost) {
        uint256 ts = totalSupply();
        uint256 diff = ts + _amount;

        if (ts == 0) {
            // totalCost = _amount * currentCost;
            totalCost = (_amount * (_amount + 1)) / 2;
        } else {
            // totalCost = currentCost * totalSupply * _amount;
            totalCost = ((diff * (diff + 1)) - (ts * (ts + 1))) / 2;
        }
    }

    function getTotalBuyBack(uint256 _amount) internal view returns (uint256 totalBuyBack) {
        uint256 ts = totalSupply();
        require(ts > 0 && ts >= _amount, "not enoought tokens to perform this task");
        uint256 diff = ts - _amount;

        totalBuyBack = ((ts * (ts + 1)) - (diff * (diff + 1))) / 2;
    }

}

