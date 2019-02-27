pragma solidity ^0.5.0;

interface IVoting {
    function isVoting() external view returns (bool);
    function getVote(uint questionId, address voter, bool descision, uint256 voteWeight) external;
    //function addQuestion(uint questionId, uint256 id, uint status, string caption, string text, uint groupId, string time) external view;
}