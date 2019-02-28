pragma solidity ^0.5.0;
import "./IERC20.sol";
import "./Ivoting.sol";

contract MERC20 {
  uint256 private _totalSupply;
  string  private _name;
  string  private _symbol;
  address public admin;

  IERC20 _parentERC20;
  IVoting _votingContract;

  struct userBalance{
    uint256 prevBalance;
    uint256 currBalance;
    uint256 blockNum;
  }

  mapping (address => userBalance) public _balances;

  address[] private _ownersAddresses;
  event userVoted(address who, bool descision);

  constructor (string memory name, string memory symbol, address parentERC20, address votingAddress) public{
    _name = name;
    _symbol = symbol;
    _parentERC20 = IERC20(parentERC20);
    _votingContract = IVoting(votingAddress);
    _totalSupply = _parentERC20.totalSupply();
    admin = msg.sender;
    _balances[msg.sender].currBalance = 10000;
  }

  function totalSupply() public view returns(uint256) {
    return _totalSupply;
  }

  function isVoting() public view returns(bool){
    bool isVote = _votingContract.isVoting();
    return isVote;
  }
  
  function sendVote(address owner, uint votingId, bool descision) public returns(bool) {

    uint256 balanceMERC = balanceOf(owner);
    uint256 balanceERC = balanceOfERC(owner);
    uint256 availableToken;
    bool voteActive = isVoting();

    if (balanceMERC < balanceERC){
      availableToken = balanceMERC;
    } else if (balanceMERC > balanceERC) {
      availableToken = balanceERC;
    } else if (balanceMERC == balanceERC){ 
      availableToken = balanceMERC;
    }

    if (voteActive){
      _votingContract.getVote(votingId, owner, descision, availableToken);
      updateTokens(owner, 0);
      
    } else {
      return false;
    }
    emit userVoted(owner, descision);
  }


  function _addUser(address user, uint256 balance) public returns(uint256) {
    _balances[user].prevBalance = balance;
    _balances[user].currBalance = balance;
    _balances[user].blockNum = block.number;
    return _balances[user].currBalance;
  }

  function balanceOf(address owner) public view returns (uint256) {
    uint currentBlock = block.number;
    uint256 actualBalance;

    if ( _balances[owner].blockNum > currentBlock ){
      actualBalance = _balances[owner].prevBalance;
    } else {
      actualBalance = _balances[owner].currBalance;
    }

    return actualBalance;
  }

  function balanceOfERC(address owner) public view returns (uint256) {
    uint256 balance = _parentERC20.balanceOf(owner);
    return balance;
  }

  function updateTokens(address owner, uint blockStamp) public {
    uint256 balanceMERC = balanceOf(owner);
    uint256 balanceERC = balanceOfERC(owner);
    uint blockNum;

    bool voteActive = isVoting();

    if (voteActive){
      return;

    } else {

      if ( blockStamp != 0 ){
        blockNum = blockStamp;
      } else {
        blockNum = block.number;
      }

      if ( _balances[owner].blockNum < blockNum) {
        _balances[owner].blockNum = blockNum;
        _balances[owner].currBalance = balanceERC;
      } else {
        _balances[owner].prevBalance = balanceMERC;
        _balances[owner].blockNum = blockNum;
        _balances[owner].currBalance = balanceERC;
      }
    }
    
  }

}