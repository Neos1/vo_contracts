pragma solidity 0.5;

import "../libs/QuestionGroups.sol";
import "../libs/Questions.sol";
import "../libs/Votings.sol";
import "./VoterInterface.sol";
import "./IERC20.sol";




/**
 * @title VoterBase
 * @dev an base difinitions for voter
 */
contract VoterBase is VoterInterface {

    Questions.List public questions;
    QuestionGroups.List public groups;
    Votings.List public votings;

    IERC20 public ERC20;

    constructor() public {
        questions.init();
        groups.init();
        votings.init();
    }

    // METHODS
    function setERC20(address _address) public returns (address erc20) {
        ERC20 = IERC20(_address);
    }
    /**
     * @notice creates new question to saveNewQuestion function
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
    ) private returns (Questions.Question memory _question) {
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
    ) external returns (uint id) {
        uint questionId = _id;
        uint group = _groupId; 
        Questions.Status status = _status; 
        string memory caption = _caption; 
        string memory text = _text; 
        uint time = _time; 
        address target = _target; 
        bytes4 method = _methodSelector; 
        string memory formula = _formula; 
        bytes32[] memory params = _parameters; 

        Questions.Question memory question = createNewQuestion( group, status, caption, text, time, target, method, formula, params);

        id = questions.save(question, questionId);

        emit NewQuestion( group, status, caption, text, time, target, method );
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
     * @return new voting id
     */

    function startNewVoting(
        uint _questionId,
        Votings.Status _status,
        uint _starterGroup
    ) external returns (uint id) {
        Votings.Voting memory voting = Votings.Voting({
            questionId: _questionId,
            status: _status,
            starterGroup: _starterGroup,
            starterAddress: msg.sender,
            startBlock: block.number
        });
        
        id = votings.save(voting);

        emit NewVoting (
            id,
            _questionId,
            _status,
            _starterGroup,
            msg.sender,
            block.number
        );
        return id;
    }

    function voting(uint _id) public view returns (
        Votings.Status status,
        string memory caption,
        string memory text,
        uint startBlock
    ){
        uint questionId = votings.voting[_id].questionId;
        return (
            votings.voting[_id].status,
            questions.question[questionId].caption,
            questions.question[questionId].text,
            votings.voting[_id].startBlock
        );
    }

    function sendVote(uint _voteId, bool _choice) public returns (bool result) {
        uint balance = ERC20.balanceOf(msg.sender);
        ERC20.transferFrom(msg.sender, address(this), balance);
        votings.voting[_voteId].voteWeigths[msg.sender] = balance;
        votings.voting[_voteId].votedUsers[msg.sender] = true;
        return true;
    }
}
