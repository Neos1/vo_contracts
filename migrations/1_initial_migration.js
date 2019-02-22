var Migrations = artifacts.require("./MERC20.sol");

module.exports = function(deployer) {
  const variables = ["Test Token", "TST", 1000000]
  const M_variables = ["Test", "MTT", '0x9C4d99880D2BEB018C7f4AD3b7a2FD30350a9A29']
  deployer.deploy(Migrations, M_variables[0], M_variables[1], M_variables[2],);
};
