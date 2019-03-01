pragma solidity ^0.5.0;

contract Voting {
  uint public _voteId = 0;
  uint public _questionId = 0;

  struct question {
    uint256 id;
    uint status;
    string caption;
    string text;
    uint groupId;
    uint time;
    // добавить values c значениями за/против 
  }

// add Voting struct
  struct voting {
    uint voteId;
    uint256 questionId;
    uint starterGroup;
    address starterAddr;
    uint start;
    uint result;
    mapping (address => bool) voters;
    mapping (address => bool) votedUsers;
    mapping (bool => uint256) votes;
  }
//
  mapping (uint => question) public _questions;
  mapping (uint=> voting) public _votings;
  mapping (bool => uint) public _votes;

  
  function startVote(uint256 questionId, uint starterGroup) public returns (bool) {
    bool isActiveVote = isVoting();
    if (isActiveVote){
        _votings[_voteId].questionId = questionId;
        _votings[_voteId].starterGroup = starterGroup;
        _votings[_voteId].starterAddr = msg.sender;
        _votings[_voteId].start = block.number;
    
        _voteId += 1; 
    } else {
        return false;
    }
    
  }

  event voteNotification(uint votingId, address voter, bool descision, uint256 voteWeight);

  function addQuestion(uint status, string memory caption, string memory text, uint groupId, uint time) public {
    _questions[_questionId].id = _questionId;
    _questions[_questionId].status = status;
    _questions[_questionId].caption = caption;
    _questions[_questionId].text = text;
    _questions[_questionId].groupId = groupId;
    _questions[_questionId].time = time; //устанавливать в блоках

    _questionId += 1;
  }

// rename to setVote 
  function setVote(uint votingId, address voter, bool descision, uint256 voteWeight) public returns(bool) {
      
    if (_votings[votingId].votedUsers[voter] == false){
        _votings[votingId].voters[voter] = descision;
        _votings[votingId].votes[descision] += voteWeight;
        _votes[descision] += voteWeight;
        _votings[votingId].votedUsers[voter] = true;
        
    } else if (_votings[votingId].votedUsers[voter] == true){
        
        return false;
    }


    emit voteNotification(votingId, voter, descision, voteWeight);
  }
  
  function getUserVote(uint votingId, address user) public view returns (bool) {
    return _votings[votingId].voters[user];
  }
  function isUserVoted(address user, uint voteId) public view returns(bool){
      return _votings[voteId].votedUsers[user];
  }
  function getDescisionWeight(bool descision) public returns (uint){
    return _votes[descision];
  }

  function isVoting() public view returns (bool) {
    uint questionId = _votings[_voteId-1].questionId;

    uint endBlock = _questions[questionId].time + _votings[_voteId-1].start;

    bool isVote;
    if (endBlock >= block.number){
      isVote = true;
    } else {
      isVote = false;
    }
    //uint number = uint(keccak256(abi.encodePacked(msg.sender, blockhash(block.number - 1))))%2;
    //bool isVote = number == 1 ? true : false;
    return isVote;
  }

}
