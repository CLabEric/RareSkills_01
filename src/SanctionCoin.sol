// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.20;

// get library versions?
import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

/// @title SanctionCoin
/// @author Eric Abt
/// @notice A fungible token that allows an admin to ban specified addresses from sending and receiving tokens.
contract SanctionCoin is ERC20("Sanction Coin", "SC"), Ownable(msg.sender) {
    /// @notice Maintains a list of banned users
    /// @dev Mapping
    mapping(address => bool) banned;

    /// @notice finds out of a user is banned or not
    /// @dev modifier that reverts if user is banned as per our 'banned' mapping
    /// @param user address to check if sanctioned or not
    modifier isNotSanctioned(address user) {
        require(!banned[user], "User not allowed to send/receive tokens");
        _;
    }

    /// @notice sets a sanction on a user
    /// @dev only contract owner can call. Sets the 'banned' mapping
    /// @param blockedUser address to block
    function setSanction(address blockedUser) external onlyOwner {
        banned[blockedUser] = true;
    }

    /// @notice A user can mint any amount of this token
    /// @dev user can't be sanctioned
    /// @param amount uint256 - number of tokens to mint
    function mint(uint256 amount) external isNotSanctioned(msg.sender) {
        _mint(msg.sender, amount);
    }

    /// @notice transfers token(s) to another address
    /// @dev overrides ERC20::transfer() and the "to" address must not be sanctioned
    /// @param to address - user that receives the token(s)
    /// @param value uint256 - amount of tokens to send
    /// @return bool
    function transfer(address to, uint256 value) public override isNotSanctioned(to) returns (bool) {
        address owner = _msgSender();
        _transfer(owner, to, value);
        return true;
    }

    /// @notice transfers tokens "from" an address to the "to" address
    /// @dev caller must be approved. Overrides ERC20::transferFrom() and "to" address must not be sanctioned
    /// @param from address - user that has tokens
    /// @param to address - user that is to receive tokens
    /// @param value uint256 - amount of tokens to transfer
    /// @return bool
    function transferFrom(address from, address to, uint256 value) public override isNotSanctioned(to) returns (bool) {
        address spender = _msgSender();
        _spendAllowance(from, spender, value);
        _transfer(from, to, value);
        return true;
    }
}
