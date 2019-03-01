var ERC = artifacts.require("./ERC20.sol");
var MERC = artifacts.require("./MERC20.sol");
var Voting = artifacts.require("./Voting.sol");

module.exports = function(deployer) {
  const variables = ["Test Token", "TST", 1000000]
  const M_variables = ["Test", "MTT", "0x9C4d99880D2BEB018C7f4AD3b7a2FD30350a9A29", "0xAC8E686D8b9b78B6575273557a87e00B3d37fA98"]
  deployer.deploy(ERC, variables[0], variables[1], variables[2],);
  deployer.deploy(MERC, M_variables[0], M_variables[1], M_variables[2], M_variables[3]);
  deployer.deploy(Voting);
};
