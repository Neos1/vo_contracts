pragma solidity ^0.5.0;
import "./IERC20.sol";

contract MERC20 {
  uint256 private _totalSupply;
  string  private _name;
  string  private _symbol;
  address private _parentERC20;
  IERC20 _parent;

  struct userBalance{
    uint256 currBalance;
    uint256 blockNum;
    uint256 balanceNext;
  }

  mapping (address => userBalance) private _balances;
  address[] private _ownersAddresses;

  constructor (string memory name, string memory symbol, address parentERC20) public{
    _name = name;
    _symbol = symbol;
    _parent = IERC20(parentERC20);
    _totalSupply = _parent.totalSupply();
    _parentERC20 = parentERC20;
  }

  function totalSupply() public view returns(uint256) {
    return _totalSupply;
  }

  function balanceOf(address owner) public view returns (uint256) {
    uint currentBlock = block.number;
    uint256 actualBalance;
    uint256 difference;

    if ( _balances[owner].blockNum > currentBlock ){
      actualBalance = _balances[owner].currBalance;
    } else if {
      actualBalance = _balances[owner].balanceNext;
      difference = _balances[owner].balanceNext - _balances[owner].currBalance;
      if (difference > 0){
        transferFrom(address(this), owner, difference)
      } else if (difference < 0){
        difference = difference * (-1);
        transferFrom(owner, address(this), difference)
      }
      _balances[owner].currBalance = _balances[owner].balanceNext;
    }

    return actualBalance;
  }

  function balanceOfERC(address owner) public view returns (uint256) {
    uint256 balance = _parent.balanceOf(owner);
    return balance;
  }

  function transferFrom(address from, address to, uint256 value) private{

  }

  function updateTokens(address owner) public view {
    uint256 balanceMERC = balanceOf(owner);
    uint256 balanceERC = balanceOfERC(owner);
  }

}