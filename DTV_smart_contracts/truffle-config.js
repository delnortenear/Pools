const Web3 = require('web3')

const { TRUFFLE_PRIVATE_KEY } = process.env;

const HDWalletProvider = require('@truffle/hdwallet-provider');

const infuraKeyMainnet = "89e41def87784184831bc5ba6f69dd20";
const infuraKeyTestnet = "89e41def87784184831bc5ba6f69dd20";
const fs = require('fs');
const mnemonic = fs.readFileSync(".secret").toString().trim();

module.exports = {
  networks: {
    mainnet: {
      provider: () => new HDWalletProvider(mnemonic, `https://mainnet.infura.io/v3/${infuraKeyMainnet}`),
      // provider: () => new HDWalletProvider(TRUFFLE_PRIVATE_KEY, `https://rpc-mumbai.matic.today`),
      network_id: 1,       // Ropsten's id
      gasPrice: Web3.utils.toWei('77', 'gwei'),
      confirmations: 2,    // # of confs to wait between deployments. (default: 0)
      timeoutBlocks: 500,  // # of blocks before a deployment times out  (minimum/default: 50)
      skipDryRun: true     // Skip dry run before migrations? (default: false for public nets )
    },
    ropsten: {
      provider: () => new HDWalletProvider(mnemonic, `https://ropsten.infura.io/v3/${infuraKeyTestnet}`),
      // provider: () => new HDWalletProvider(TRUFFLE_PRIVATE_KEY, `https://rpc-mumbai.matic.today`),
      network_id: 3,       // Ropsten's id
      gasPrice: Web3.utils.toWei('77', 'gwei'),
      confirmations: 2,    // # of confs to wait between deployments. (default: 0)
      timeoutBlocks: 200,  // # of blocks before a deployment times out  (minimum/default: 50)
      skipDryRun: true     // Skip dry run before migrations? (default: false for public nets )
    }
  },
plugins: [
    'truffle-plugin-verify'
  ],

  api_keys: {
    etherscan: 'IJRAMKKE5MGJPZU2BJP6ZGRVJDRDGHYM57'
  },
  compilers: {
    solc: {
      version: "0.6.0",    // Fetch exact version from solc-bin (default: truffle's version)
      // docker: true,        // Use "0.5.1" you've installed locally with docker (default: false)
       settings: {          // See the solidity docs for advice about optimization and evmVersion
        optimizer: {
          enabled: true,
          runs: 200
        },
      //  evmVersion: "byzantium"
       }
    },
  },
};
