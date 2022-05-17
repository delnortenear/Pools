const HDWalletProvider = require("@truffle/hdwallet-provider");
const Web3 = require("web3");

const {
  TRUFFLE_PRIVATE_KEY,
  SUPER_ADMIN_ADDRESS,
  GENERAL_PARTNER_ADDRESS,
  LIMITED_PARTNER_ADDRESS,
  TEAM_ADDRESS,
  STURTAP_TEAM_ADDRESS,
  REFERER_ADDRESS,
  TOKEN_ADDRESS,
  LOCKED,
  RATE,
  INTEREST_FEE,
  ANUAL_PRECENT,
  POOL_REGISTRY_ADDRESS,
  TOKEN_REQUEST_CONTRACT
} = process.env;

// const provider = new HDWalletProvider(
//   TRUFFLE_PRIVATE_KEY,
//   `https://mainnet.infura.io/v3/9f455763426b46e68c3ef87e37b429c1`
// );

// const provider = new HDWalletProvider(
//   TRUFFLE_PRIVATE_KEY,
//   `https://ropsten.infura.io/v3/9f455763426b46e68c3ef87e37b429c1`
// );

const provider = new HDWalletProvider(
  TRUFFLE_PRIVATE_KEY,
  `https://kovan.infura.io/v3/bbf2b9fbd8744d40a6172fca01ad3388`
);

const web3 = new Web3(provider);

const SUPER_ADMIN_ROLE = web3.utils.sha3("SUPER_ADMIN_ROLE");

const InvestmentPool = artifacts.require("InvestmentPool");

module.exports = function (deployer, network, accounts) {
  deployer.then(async () => {
    try {
      console.log('--------------------------------------------------------------------------------------------');

      const balanceDeployerStart = web3.utils.fromWei(await web3.eth.getBalance(accounts[0]), 'ether');
      console.log(`| Network: ${network} / deployer: ${accounts[0]} | Balance: ${balanceDeployerStart} ETH`);

      console.log(`|----------------------------------------------------------`);
      console.log(` Super admin address ${SUPER_ADMIN_ADDRESS}`);
      console.log(` Balance ${web3.utils.fromWei(await web3.eth.getBalance(SUPER_ADMIN_ADDRESS), 'ether')} ETH`);
      console.log(`|----------------------------------------------------------`);
      console.log(` General partner address second ${GENERAL_PARTNER_ADDRESS}`);
      console.log(` Balance ${web3.utils.fromWei(await web3.eth.getBalance(GENERAL_PARTNER_ADDRESS), 'ether')} ETH`);
      console.log(`|----------------------------------------------------------`);
      console.log(` Limited partner address third ${LIMITED_PARTNER_ADDRESS}`);
      console.log(` Balance ${web3.utils.fromWei(await web3.eth.getBalance(LIMITED_PARTNER_ADDRESS), 'ether')} ETH`);
      console.log(`|----------------------------------------------------------`);
      console.log(` Team address ${TEAM_ADDRESS}`);
      console.log(` Balance ${web3.utils.fromWei(await web3.eth.getBalance(TEAM_ADDRESS), 'ether')} ETH`);
      console.log(`|----------------------------------------------------------`);
      console.log(` Sturtap team address ${STURTAP_TEAM_ADDRESS}`);
      console.log(` Balance ${web3.utils.fromWei(await web3.eth.getBalance(STURTAP_TEAM_ADDRESS), 'ether')} ETH`);
      console.log(`|----------------------------------------------------------`);
      console.log(` Referer address ${REFERER_ADDRESS}`);
      console.log(` Balance ${web3.utils.fromWei(await web3.eth.getBalance(REFERER_ADDRESS), 'ether')} ETH`);
      console.log(`|----------------------------------------------------------`);

      await deployer.deploy(
        InvestmentPool,
        TOKEN_ADDRESS,
        LOCKED,
        RATE,
        INTEREST_FEE,
        ANUAL_PRECENT,
        SUPER_ADMIN_ADDRESS,
        GENERAL_PARTNER_ADDRESS,
        LIMITED_PARTNER_ADDRESS,
        TEAM_ADDRESS,
        STURTAP_TEAM_ADDRESS,
        REFERER_ADDRESS,
        POOL_REGISTRY_ADDRESS,
        TOKEN_REQUEST_CONTRACT
      );

      const investmentPool = await InvestmentPool.deployed();
      const pool = new web3.eth.Contract(investmentPool.abi, investmentPool.address);

      console.log('--------------------------------------------------------------------');
      console.log('--------------------------------------------------------------------');

      console.log(`Investment Pool address:   ${investmentPool.address}`);
      console.log(`Token address:             ${await pool.methods.token().call()}`);
      console.log(`Locked:                    ${await pool.methods.locked().call()}`);
      console.log(`Rate:                      ${await pool.methods.rate().call()}`);
      console.log(`Interest fee:              ${await pool.methods.interestFee().call()}`);
      console.log(`Anual precent:             ${await pool.methods.anualPrecent().call()}`);

      console.log('--------------------------------------------------------------------');
      console.log('--------------------------------------------------------------------');

      console.log(`Deployer contract isAdmin:   ${await pool.methods.hasRole(SUPER_ADMIN_ROLE, accounts[0]).call()}`);
      await pool.methods.renounceRole(SUPER_ADMIN_ROLE, accounts[0]).send({ from: accounts[0] });
      console.log(`Deployer contract isAdmin:   ${await pool.methods.hasRole(SUPER_ADMIN_ROLE, accounts[0]).call()}`);

      return;

    } catch (error) {
      console.log("| Deploy error!");
      console.log(error);
    }
  });
};