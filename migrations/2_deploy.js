const Questions = artifacts.require('Questions.sol');
const QuestionGroups = artifacts.require('QuestionGroups.sol');
const Voter = artifacts.require('Voter.sol');
const Project = artifacts.require('Project.sol');

module.exports = async function(deployer, network, accounts) {
    const config = {
        from: accounts[0]
    };

    return deployer.deploy(Questions, config) 
        .then(() => deployer.deploy(QuestionGroups, config))
        .then(() => deployer.link(Questions, [Voter]))
        .then(() => deployer.link(QuestionGroups, [Voter]))
        .then(() => deployer.deploy(Voter, config))
        .then(() => deployer.deploy(Project, config))
}
