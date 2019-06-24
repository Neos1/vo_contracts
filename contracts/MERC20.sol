pragma solidity 0.4;

import "./IERC20.sol";
import "./MERCInterface.sol";

contract MERC20 is MERCInterface {
  string private _name;
  string private _symbol;
  uint256 private _decimals;
  address public admin;
  IERC20 private parentERC;

  mapping (address => userBalance) balances;
  address[] users;

  constructor (string name, string symbol, address _parentAddr ) public {
    _name = name;
    _symbol = symbol;
    parentERC = IERC20(_parentAddr);
    _decimals = parentERC.totalSupply();
    admin = msg.sender;
    balances[msg.sender].currBalance = _decimals;
  }


  struct userBalance{
    uint256 prevBalance;
    uint256 currBalance;
    uint256 blockNum;
  }


  function symbol() public view returns(string) {
    return _symbol;
  }
  function name() public view returns(string) {
    return _name;
  }
  function totalSupply() public view returns(uint256) {
    return _decimals;
  }

  function balanceOfERC(address owner) public returns (uint256) {
    uint256 balance = parentERC.balanceOf(owner);
    return balance;
  }

  function balanceOf(address who) returns (uint256) {
    return balances[who].currBalance;
  }

  function findUser(address user) returns (uint) {
    uint usersLength = users.length;
		uint matched = 0;
		for (uint i = 0; i < usersLength; i++) {
			if (users[i] == user) {
				matched = i;
			}
		}
		return matched;
  }

  function findEmptyUser() returns (uint) {
    uint usersLength = users.length;
		uint matched = 0;
		for (uint i = 0; i < usersLength; i++) {
			if (users[i] == 0) {
				matched = i;
			}
		}
		return matched;
  }

  function _addUser(address user, uint256 balance) public returns(uint256) {
		uint isUser = findUser(user);
		uint emptyIndex = findEmptyUser();
		if (isUser == 0) {
			balances[user].prevBalance = balance;
			balances[user].currBalance = balance;
			balances[user].blockNum = block.number;
			users[emptyIndex] = user;
		}
    return balances[user].currBalance;
  }

  function transferFrom(address _who, address _to, uint256 value) {
    require(_who != address(0), "MERC20: transfer from the zero address");
    require(_to != address(0), "MERC20: transfer to the zero address");

    balances[_who].prevBalance = balances[_who].currBalance;
    balances[_to].prevBalance = balances[_to].currBalance;
    balances[_who].currBalance = balances[_who].currBalance - value;
    balances[_to].currBalance = balances[_to].currBalance + value;
  }

  function setAdmin(address _newAdmin) {
    admin = _newAdmin;
  }

}