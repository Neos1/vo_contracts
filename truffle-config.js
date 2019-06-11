require('dotenv').config()

const networks = {
    development: {
        host: "localhost",
        port: 7545,
        network_id: "5777",
        gasLimit: 7900000
    },
    private: {
        host: process.env.PRIVATE_NETWORK_HOST || 'localhost',
        port: process.env.PRIVATE_NETWORK_PORT || '7545',
        network_id: process.env.PRIVATE_NETWORK_ID || '5777',
        gas: process.env.PRIVATE_NETWORK_GAS || '9000000',
        gasLimit: process.env.PRIVATE_NETWORK_GAS_LIMIT || '9000000'
    }
};

module.exports = {
    networks,
    compilers: {
        solc: {
            version: "0.4.24",
        }
    },
    solc: {
        optimizer: {
            enabled: true,
            runs: 200
        }
    },
};
