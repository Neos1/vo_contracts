const Questions = artifacts.require('Questions.sol');
const QuestionGroups = artifacts.require('QuestionGroups.sol');
const Votings = artifacts.require('Votings.sol');
const Voter = artifacts.require('Voter.sol');
const Project = artifacts.require('Project.sol');

module.exports = async function(deployer, network, accounts) {
    const config = {
        from: accounts[0]
    };

    return deployer.deploy(Questions, config) 
        .then(() => deployer.deploy(QuestionGroups, config))
        .then(() => deployer.deploy(Votings, config))
        .then(() => deployer.deploy(Votings, [Voter]))
        .then(() => deployer.link(Questions, [Voter]))
        .then(() => deployer.link(QuestionGroups, [Voter]))
        .then(() => deployer.deploy(Voter, "0x8145723A76C46321BdD40906681b1D5Eec1b18D9", config))
        .then(() => deployer.deploy(Project, config))
}
