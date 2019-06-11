const Voter = artifacts.require('./Voter.sol');


contract('Voter', async (accounts) => {
    const system = accounts[0];
    
    /*it('should return address of ERC20', async () => {
        let address = await voter.getERCAddress.call(accounts[0]);
        assert.equal(address, '0x8145723A76C46321BdD40906681b1D5Eec1b18D9');
    })*/

    it('should add new question', async () => {
        let voter = await Voter.deployed();
        await voter.saveNewQuestion([1, 0, 10], 1, 'test', 'testestestestest', voter, 0x00000000, [0, 0, 1, 20, 0], ['0x74657374', '0x696e74'], system)
    })
});
