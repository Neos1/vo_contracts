pragma solidity ^0.5.0;

contract Voting {

  struct Question {
    uint256 id;
    uint status;
    string caption;
    string text;
    uint groupId;
    string time;
    mapping (address => bool) votes;
  }

  mapping (uint => Question) public _questions;

  function addQuestion(uint questionId, uint256 id, uint status, string memory caption, string memory text, uint groupId, string memory time) public {
    _questions[questionId].id = id;
    _questions[questionId].status = status;
    _questions[questionId].caption = caption;
    _questions[questionId].text = text;
    _questions[questionId].groupId = groupId;
    _questions[questionId].time = time;
  }

  function getVote(uint questionId, address voter, bool descision, uint256 voteWeight) public returns(uint, address, bool, uint256) {
    _questions[questionId].votes[voter] = descision;
    return(questionId, voter, descision, voteWeight);
  }
  
  function getQuestion(uint questionId) public returns (string memory, string memory) {
    return(_questions[questionId].caption, _questions[questionId].caption);
  }

  function isVoting() public view returns (bool) {
    uint number = uint(keccak256(abi.encodePacked(msg.sender, blockhash(block.number - 1))))%2;
    bool isVote = number == 1 ? true : false;
    return isVote;
  }

}
