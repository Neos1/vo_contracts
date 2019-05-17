pragma solidity 0.5;

library Votings {

  enum Status {ACTIVE, ENDED}

  struct Voting {
    // ? question id used for vote
    uint questionId;
    // ? vote status
    Status status;
    // ? group of users, who started vote
    uint starterGroup;
    // ? user, who started the voting
    address starterAddress;
    // ? block when voting was started
    uint startBlock;
    // ? contains pairs of (address => vote) for every user
    mapping (address => bool) votes;
    /** ? contains pairs of (address => bool) for each users:
          true - user voted
          false - user not voted
    */
    mapping (address => bool) votedUsers;
    // contains total weights for voting variants
    mapping (address => uint) voteWeigths;
  }

  struct List {
    uint votingIdIndex;
    mapping (uint => Voting) voting;
  }

  function init(List storage _self) internal {
        _self.votingIdIndex = 1;
    }

  function save(List storage _self, Voting memory _voting) internal returns (uint id) {
        uint votingId = _self.votingIdIndex;
        _self.voting[votingId] = _voting;
        _self.votingIdIndex++;
        return votingId;
    }
}