pragma solidity 0.4;

interface MERCInterface {


  function symbol() external  returns (string);

  function name() external  returns (string);

  function totalSupply() external  returns (uint256);

  function getUsers() external  returns (address[]);

  function balanceOf(address who) external returns (uint256) ;

  function findUser(address who) external returns(uint256);

  function findEmptyUser() external returns(uint256);

  function _addUser(address who, uint256 balance) external returns (uint256);

  function transferFrom(address who, address to, uint256 value) external;

  function setAdmin(address who) external ;
}