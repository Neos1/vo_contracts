const expectThrow = async promise => {
    try {
        await promise;
    } catch (error) {
        const invalidResponse = error.message.search('Invalid JSON RPC response') >= 0
        const invalidJump = error.message.search('invalid JUMP') >= 0;
        const outOfGas = error.message.search('out of gas') >= 0;
        const other = error.message.search('exited with an error') >= 0;
        assert(
            invalidResponse || invalidJump || outOfGas || other,
            "Expected throw, got '" + error + "' instead",
        );
        return;
    }
    assert.fail('Expected throw not received');
};

module.exports = expectThrow;