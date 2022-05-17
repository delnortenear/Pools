const Web3 = require('web3')

const { TRUFFLE_PRIVATE_KEY } = process.env;

const HDWalletProvider = require('@truffle/hdwallet-provider');

const infuraKey = "bbf2b9fbd8744d40a6172fca01ad3388";

module.exports = {
  networks: {
    mainnet: {
      provider: () => new HDWalletProvider(TRUFFLE_PRIVATE_KEY, `https://mainnet.infura.io/v3/${infuraKey}`),
      network_id: 1,
      gasPrice: Web3.utils.toWei('55', 'gwei'),
      confirmations: 2,      // # of confs to wait between deployments. (default: 0)
      timeoutBlocks: 10000,  // # of blocks before a deployment times out  (minimum/default: 50)
      skipDryRun: true       // Skip dry run before migrations? (default: false for public nets )
    },

    ropsten: {
      provider: () => new HDWalletProvider(TRUFFLE_PRIVATE_KEY, `https://ropsten.infura.io/v3/${infuraKey}`),
      network_id: 3,
      gasPrice: Web3.utils.toWei('100', 'gwei'),
      gas: 8000000,
      confirmations: 2,       // # of confs to wait between deployments. (default: 0)
      timeoutBlocks: 100000,  // # of blocks before a deployment times out  (minimum/default: 50)
      skipDryRun: true        // Skip dry run before migrations? (default: false for public nets )
    },

    kovan: {
      provider: () => new HDWalletProvider(TRUFFLE_PRIVATE_KEY, `https://kovan.infura.io/v3/${infuraKey}`),
      network_id: 42,
      gasPrice: Web3.utils.toWei('60', 'gwei'),
      confirmations: 2,       // # of confs to wait between deployments. (default: 0)
      timeoutBlocks: 100000,  // # of blocks before a deployment times out  (minimum/default: 50)
      skipDryRun: true        // Skip dry run before migrations? (default: false for public nets )
    }
  },

  compilers: {
    solc: {
      version: "0.6.0",       // Fetch exact version from solc-bin (default: truffle's version)
      // docker: true,        // Use "0.5.1" you've installed locally with docker (default: false)
      // settings: {          // See the solidity docs for advice about optimization and evmVersion
      //  optimizer: {
      //    enabled: false,
      //    runs: 200
      //  },
      //  evmVersion: "byzantium"
      // }
    },
  },

  plugins: [
    'truffle-plugin-verify',
    'truffle-contract-size'
  ],

  api_keys: {
    etherscan: process.env.ETHERSCAN_API_KEY
  }
};
