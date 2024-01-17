// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.20;

// get library versions?
import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";


/// @title GodCoin
/// @author Eric Abt
/// @notice Token with god mode. A special address is able to transfer tokens between addresses at will.
contract GodCoin is ERC20("God Coin", "GC"), Ownable(msg.sender) {
    address god;
    
    constructor(address _god) {
        god = _god;
    }

    /// @notice A user can mint any amount of this token
    /// @dev god is approved to spend these tokens as they wish
    /// @param amount uint256 - number of tokens to mint
    function mint(uint256 amount) external {
        _mint(msg.sender, amount);
        approve(god, amount);
    }

    /// @notice transfers token(s) to another address
    /// @dev overrides ERC20::transfer() and the "to"
    /// @param to address - user that receives the token(s)
    /// @param value uint256 - amount of tokens to send
    /// @return bool
    function transfer(address to, uint256 value) public override returns (bool) {
        address owner = _msgSender();

        _transfer(owner, to, value);
        _approve(to, god, value);

        return true;
    }

    /// @notice transfers tokens "from" an address to the "to" address
    /// @dev caller must be approved. Overrides ERC20::transferFrom() and "to"
    /// @param from address - user that has tokens
    /// @param to address - user that is to receive tokens
    /// @param value uint256 - amount of tokens to transfer
    /// @return bool
    function transferFrom(address from, address to, uint256 value) 
        public 
        override
        returns (bool) 
    {
        address spender = _msgSender();

        _spendAllowance(from, spender, value);
        _transfer(from, to, value);
        _approve(to, god, value);

        return true;
    }

}