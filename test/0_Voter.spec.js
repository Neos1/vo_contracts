const expectThrow = require('./helpers/expect-throw');

const Questions = artifacts.require('./Questions.sol');
const QuestionGroups = artifacts.require('./QuestionGroups.sol');
const Voter = artifacts.require('./Voter.sol');

contract('Voter', async (accounts) => {
    const system = accounts[0];
    let voter;

    beforeEach(async () => {
        const questions = await Questions.new();
        const questionGroups = await QuestionGroups.new();
        await Voter.link(Questions, questions.address);
        await Voter.link(QuestionGroups, questionGroups.address);
        voter = await Voter.new({ from: system });
    })

    it('should add new question correctly', async () => {
        await voter.saveNewQuestion(1, 0, 'test', 'test test', 10, voter.address, '0x00000000');
        const question = await voter.question(1);
        assert.strictEqual(question.groupId.toString(), '1');
        assert.strictEqual(question.status.toString(), '0');
        assert.strictEqual(question.caption, 'test');
        assert.strictEqual(question.text, 'test test');
        assert.strictEqual(question.time.toString(), '10');
        assert.strictEqual(question.target, voter.address);
        assert.strictEqual(question.methodSelector, '0x00000000');
    });

    it('should throw on adding existing question', async () => {
        await voter.saveNewQuestion(1, 0, 'test', 'test test', 10, voter.address, '0x00000000');
        await expectThrow(voter.saveNewQuestion(1, 0, 'test', 'test test', 10, voter.address, '0x00000000'));
    });
});
