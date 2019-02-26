pragma solidity ^0.5.0;

contract Voting {
  struct Conditions {}

  struct Question {
    uint256 id;
    uint status;
    string caption;
    string text;
    uint groupId;
    string time;
    Conditions conditions;
  }

  mapping (uint => Question) public _questions;


  function isVoting() public view returns (uint) {
   return uint(keccak256(abi.encodePacked(msg.sender, blockhash(block.number - 1))))%2;
  }

}
