pragma solidity 0.5;

import "../libs/QuestionGroups.sol";
import "../libs/Questions.sol";
import "../libs/Votings.sol";
import "./VoterInterface.sol";


/**
 * @title VoterBase
 * @dev an base difinitions for voter
 */
contract VoterBase is VoterInterface {

    Questions.List public questions;
    QuestionGroups.List public groups;
    Votings.List public votings;

    constructor() internal {
        questions.init();
        groups.init();
        votings.init();
    }

    // METHODS
    function createNewQuestion(
        uint _groupId,
        Questions.Status _status,
        string memory _caption,
        string memory _text,
        uint _time,
        address _target,
        bytes4 _methodSelector,
        string memory _formula,
        bytes32[] memory _parameters
    ) internal returns (Questions.Question memory _question) {
        Questions.Question memory question = Questions.Question({
            groupId: _groupId,
            status: _status,
            caption: _caption,
            text: _text,
            time: _time,
            target: _target,
            methodSelector: _methodSelector,
            formula: _formula,
            parameters: _parameters
        });

        return question;
    }

    /**
     * @notice adds new question to question library
     * @param _groupId question group id
     * @param _status question status
     * @param _caption question name
     * @param _text question description
     * @param _time question length
     * @param _target target address to call
     * @param _methodSelector method to call
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
    ) external returns (uint id) {
        // validate params
        // call questions.save()
        // example
        Questions.Question memory question = createNewQuestion(
            _groupId,
            _status,
            _caption,
            _text,
            _time,
            _target,
            _methodSelector,
            _formula,
            _parameters
        );
        id = questions.save(question, _id);
        emit NewQuestion(
            id,
            _groupId,
            _status,
            _caption,
            _text,
            _time,
            _target,
            _methodSelector
        );
        return id;
    }

    /**
     * @notice adds new question to question library
     * @param _groupType question group type
     * @param _name question group name
     * @return new question id
     */
    function saveNewGroup(
        QuestionGroups.GroupType _groupType,
        string calldata _name
    ) external returns (uint id) {
        // validate params
        // call groups.save()
    }

    /**
     * @notice gets question data
     * @param _id question id
     * @return question data
     */
    function question(uint _id) public view returns (
        uint groupId,
        Questions.Status status,
        string memory caption,
        string memory text,
        uint time,
        address target,
        bytes4 methodSelector,
        string memory _formula,
        bytes32[] memory _parameters
    ) {
        uint id = _id;

        return (
            questions.question[id].groupId,
            questions.question[id].status,
            questions.question[id].caption,
            questions.question[id].text,
            questions.question[id].time,
            questions.question[id].target,
            questions.question[id].methodSelector,
            questions.question[id].formula,
            questions.question[id].parameters
        );
    }

/**
     * @notice adds new voting to voting library
     * @param _questionId question id
     * @param _status voting status
     * @param _starterGroup group which started voting
     * @param _starterAddress user which started voting
     * @param _startBlock block number when voting id started
     * @return new voting id
     */
    function startNewVote(
        uint _questionId,
        Votings.Status _status,
        uint _starterGroup,
        address _starterAddress,
        uint _startBlock
    ) external returns (uint id) {
        
        Votings.Voting memory voting = Votings.Voting({
            questionId: _questionId,
            status: _status,
            starterGroup: _starterGroup,
            starterAddress: _starterAddress,
            startBlock: _startBlock
        });
        id = votings.save(voting);
        emit NewVoting (
            id,
            _questionId,
            _status,
            _starterGroup,
            _starterAddress,
            _startBlock
        );
        return id;
    }
}
