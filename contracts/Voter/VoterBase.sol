pragma solidity 0.4;

import "../libs/QuestionGroups.sol";
import "../libs/UserGroups.sol";
import "../libs/Questions.sol";
import "../libs/Votings.sol";
import "./VoterInterface.sol";
import "../IERC20.sol";




/**
 * @title VoterBase
 * @dev an base difinitions for voter
 */
contract VoterBase is VoterInterface {

    Questions.List public questions;
    QuestionGroups.List public groups;
    Votings.List public votings;
    UserGroups.List public userGroups;

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
    /*
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
        uint[] memory _idsAndTime,
        Questions.Status _status,
        string memory _caption,
        string memory _text,
        address _target,
        bytes4 _methodSelector,
        uint[] memory _formula,
        bytes32[] memory _parameters
    ) private returns (Questions.Question memory _question) {
        Questions.Question memory question = Questions.Question({
            groupId: _idsAndTime[1],
            status: _status,
            caption: _caption,
            text: _text,
            time: _idsAndTime[2],
            target: _target,
            methodSelector: _methodSelector,
            formula: _formula,
            parameters: _parameters
        });
        questions.save(question, _idsAndTime[0]);

        emit NewQuestion( _idsAndTime[1], _status, _caption, _text, _idsAndTime[0], _target, _methodSelector );
        return question;
    }
    

    /*
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
        uint[] _idsAndTime,
        Questions.Status _status,
        string  _caption,
        string  _text,
        address _target,
        bytes4 _methodSelector,
        uint[]  _formula,
        bytes32[] _parameters

    ) external returns (bool _saved){
        /*Questions.Status status = _status; 
        string memory caption = _caption; 
        string memory text = _text; 
        address target = _target; 
        bytes4 methodSelector = _methodSelector; 
        string memory formula = _formula; 
        bytes32[] memory parameters = _parameters;*/ 
        Questions.Question memory question = createNewQuestion( 
            _idsAndTime, 
            _status, 
            _caption, 
            _text, 
            _target, 
            _methodSelector, 
            _formula, 
            _parameters
        );
        return true;
    }

    /**
     * @notice adds new question to question library
     * @param _groupType question group type
     * @param _name question group name
     * @return new question id
     */
    function saveNewGroup(
        QuestionGroups.GroupType _groupType,
        string _name
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
        uint[] memory _formula,
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

    function getCount() external returns (uint length) {
        uint count = questions.questionIdIndex;
        return count;
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
        uint _starterGroup,
        bytes _data
    ) external returns (uint id) {
        uint start = block.timestamp;
        uint _endTime = start + (questions.question[_questionId].time * 60);
        uint lastVoting = this.getVotingsCount();
        Votings.Voting memory voting = Votings.Voting({
            questionId: _questionId,
            status: _status,
            starterGroup: _starterGroup,
            starterAddress: msg.sender,
            startTime: block.timestamp,
            endTime: _endTime,
            data: _data
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

    function voting(uint _id) external view returns (
        uint id,
        Votings.Status status,
        string memory caption,
        string memory text,
        uint startTime,
        uint endTime,
        bytes data
    ){
        uint votingId = _id;
        uint questionId = votings.voting[_id].questionId;
        return (
            votings.voting[votingId].questionId,
            votings.voting[votingId].status,
            questions.question[questionId].caption,
            questions.question[questionId].text,
            votings.voting[votingId].startTime,
            votings.voting[votingId].endTime,
            votings.voting[votingId].data
        );
    }
    function getVotingsCount() external returns (uint count) {
        return votings.votingIdIndex;
    }
    function getVotingDescision(uint _id) external returns (uint result) {
        return votings.descision[_id];
    }   

    function closeVoting() external {
        uint votingId = votings.votingIdIndex - 1;
        uint questionId = votings.voting[votingId].questionId;
        
        uint[] storage formula = questions.question[questionId].formula;
        uint256 positiveVotes = votings.voting[votingId].descisionWeights[1][address(ERC20)];
        uint256 negativeVotes = votings.voting[votingId].descisionWeights[2][address(ERC20)];
        uint256 totalSupply = ERC20.totalSupply();

        uint entity = formula[0];
        uint parity = formula[2];
        uint percent = formula[3];
        uint quorumPercent;
        uint condition;

        uint256 quorum = positiveVotes + negativeVotes;
        uint descision;

        if (parity == 1) {
            if (formula[4] != 0) {
                condition = formula[4];
            } else {
                condition = 0;
            }
        }
        if (parity == 0) {
            quorumPercent = (quorum/totalSupply) * 100;
        } else if (parity == 1) {
            if (condition == 0) {
                quorumPercent = (positiveVotes/quorum)*100;
            } else if (condition == 1) {
                quorumPercent = (positiveVotes/totalSupply)*100;
            }
        }

        if (quorumPercent >= percent) {
            if (positiveVotes > negativeVotes) {
                descision = 1;
                address(this).call(votings.voting[votingId].data);
            } else if (positiveVotes > negativeVotes) {
                descision = 2;
            } else if (positiveVotes == negativeVotes) {
                descision = 0;
            }
        }


        votings.descision[votingId] = descision;
        votings.voting[votingId].status = Votings.Status.ENDED;
    }

    function getVotes(uint _votingId) external returns (uint256[3] memory _votes) {
        uint256[3] memory votes;
        votes[0] = votings.voting[_votingId].descisionWeights[1][address(ERC20)];
        votes[1] = votings.voting[_votingId].descisionWeights[2][address(ERC20)];
        votes[2] = ERC20.totalSupply();
        return votes;
    }

    function returnTokens() public returns (bool status){
        uint votingId = votings.votingIdIndex - 1;
        uint256 weight = votings.voting[votingId].voteWeigths[address(ERC20)][msg.sender];
        ERC20.transferFrom(address(this), msg.sender, weight);
        return true;
    }


    function sendVote(uint _choice) external returns (uint result, uint256 votePos, uint256 voteNeg) {
        uint _voteId = votings.votingIdIndex - 1;
        uint timestamp = votings.voting[_voteId].endTime;
        uint256 balance = ERC20.balanceOf(msg.sender);

        if (block.timestamp < timestamp ) {
            if (votings.voting[_voteId].votes[address(ERC20)][msg.sender] == 0) {
                ERC20.approve(msg.sender, address(this), balance);
                ERC20.transferFrom(msg.sender, address(this), balance);
                votings.voting[_voteId].votes[address(ERC20)][msg.sender] = _choice;
                votings.voting[_voteId].voteWeigths[address(ERC20)][msg.sender] = balance;
                votings.voting[_voteId].descisionWeights[_choice][address(ERC20)] += balance;
            }
        } else {
            this.closeVoting();
        }
        return (
            votings.voting[_voteId].votes[address(ERC20)][msg.sender] = _choice,
            votings.voting[_voteId].descisionWeights[1][address(ERC20)],
            votings.voting[_voteId].descisionWeights[2][address(ERC20)]
        );
    }

     
    function getERCAddress() external returns (address _address) {
        return address(ERC20);
    }


    function getUserBalance() external returns (uint256 balance) {
        uint256 _balance = ERC20.balanceOf(msg.sender);
        return _balance;
    }

    function getERCTotal() returns (uint256 balance) {
        return ERC20.totalSupply();
    }
    function getERCSymbol() returns (string symbol) {
        return ERC20.symbol();
    }

    function getUserVote() external returns (uint vote) {
        uint _voteId = votings.votingIdIndex;
        return votings.voting[_voteId].votes[address(ERC20)][msg.sender];
    }
    function getUserWeight() external returns (uint256 weight) {
        uint _voteId = votings.votingIdIndex;
        return votings.voting[_voteId].voteWeigths[address(ERC20)][msg.sender];
    }
    function transferERC20(address _who, uint256 _value) external returns (uint256 newBalance) {
        ERC20.transferFrom(msg.sender, _who, _value);
        return ERC20.balanceOf(msg.sender);
    }

    function addresses() external returns (address user, address instance) {
        return (
            msg.sender,
            address(this)
        );
    }

    function saveNewUserGroup (string _name, address _address,  string _type) {
        UserGroups.UserGroup memory userGroup = UserGroups.UserGroup({
            name: _name,
            groupType: _type,
            status: UserGroups.GroupStatus.ACTIVE,
            groupAddr: _address
        });
        userGroups.save(userGroup);
    } 
}
