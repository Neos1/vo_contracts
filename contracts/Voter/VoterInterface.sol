pragma solidity 0.5;

import "../libs/QuestionGroups.sol";
import "../libs/Questions.sol";
import "../libs/Votings.sol";


/**
 * @title VoterInterface
 * @dev an interface for voter
 */
interface VoterInterface {
    // LIBRARIES
    using QuestionGroups for QuestionGroups.List;
    using Questions for Questions.List;
    using Votings for Votings.List;

    
    // DIFINTIONS
    // new question added event
    event NewQuestion(
        uint groupId,
        Questions.Status status,
        string caption,
        string text,
        uint time,
        address target,
        bytes4 methodSelector
    );
    // new Votings added event
    event NewVoting(
        uint id,
        uint questionId,
        Votings.Status status,
        uint starterGroup,
        address starterAddress,
        uint startblock
    );

    // METHODS
    /**
     * @notice adds new question to question library
     * @param _groupId question group id
     * @param _status question status
     * @param _caption question name
     * @param _text question description
     * @param _time question length
     * @param _target target address to call
     * @param _methodSelector method to call
     * @param _formula voting formula
     * @param _parameters parameters of inputs
     * @return new question id
     */
    function saveNewQuestion(
        uint _id,
        uint _groupId,
        Questions.Status _status,
        string calldata _caption,
        string calldata _text,
        uint _time,
        address _target,
        bytes4 _methodSelector,
        string calldata _formula,
        bytes32[] calldata _parameters
    ) external returns (uint id);

    /**
     * @notice adds new question to question library
     * @param _groupType question group type
     * @param _name question group name
     * @return new question id
     */
    function saveNewGroup(
        QuestionGroups.GroupType _groupType,
        string calldata _name
    ) external returns (uint id);

    /**
     * @notice gets question data
     * @param _id question id
     * @return question data
     */
    function question(
        uint _id
    ) external view returns (
        uint groupId,
        Questions.Status status,
        string memory caption,
        string memory text,
        uint time,
        address target,
        bytes4 methodSelector,
        string memory _formula,
        bytes32[] memory _parameters
    );

    function startNewVoting( 
        uint questionId,
        Votings.Status status,
        uint starterGroup
    ) external returns (uint id);

    function voting(uint id) external view returns (
        Votings.Status status,
        string memory caption,
        string memory text,
        uint timeLeft
    );
}
