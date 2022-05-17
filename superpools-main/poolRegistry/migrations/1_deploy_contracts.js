const HDWalletProvider = require("@truffle/hdwallet-provider");
const Web3 = require("web3");

const {
  TRUFFLE_PRIVATE_KEY,
  TEAM_ADDRESS
} = process.env;

// const provider = new HDWalletProvider(
//   TRUFFLE_PRIVATE_KEY,
//   `https://mainnet.infura.io/v3/9f455763426b46e68c3ef87e37b429c1`
// );

// const provider = new HDWalletProvider(
//   TRUFFLE_PRIVATE_KEY,
//   `https://ropsten.infura.io/v3/5267e382cf6242ceae0fdf1e2510ac7d`
// );

const provider = new HDWalletProvider(
  TRUFFLE_PRIVATE_KEY,
  `https://kovan.infura.io/v3/f41d4178dbc44c9093890f7c8d8da5f2`
);

const web3 = new Web3(provider);

const PoolRegistry = artifacts.require("PoolRegistry");
const CreatorInvestmentPool = artifacts.require("CreatorInvestmentPool");
const AssetsManageTeam = artifacts.require("AssetsManageTeam");
const ReturnInvestmentLpartner = artifacts.require("ReturnInvestmentLpartner");
const CalculateWithdrawEth = artifacts.require("CalculateWithdrawEth");
const Oracle = artifacts.require("Oracle");

module.exports = function (deployer, network, accounts) {
  deployer.then(async () => {
    try {
      console.log('--------------------------------------------------------------------------------------------');

      const balanceDeployerStart = web3.utils.fromWei(await web3.eth.getBalance(accounts[0]), 'ether');
      console.log(`| Network: ${network} / deployer: ${accounts[0]} | Balance: ${balanceDeployerStart} ETH`);

      console.log(`|----------------------------------------------------------`);
      console.log(` Team role pool registry address       ${TEAM_ADDRESS}`);
      console.log(` Balance ${web3.utils.fromWei(await web3.eth.getBalance(TEAM_ADDRESS), 'ether')} ETH`);
      console.log(`|----------------------------------------------------------`);

      console.log('******************************************************************************');
      console.log('* RETURN INVESTMENT LIMITED PARTNER CONTRACT                                 *');
      console.log('******************************************************************************');

      await deployer.deploy(ReturnInvestmentLpartner);

      const returnInvestmentLpartner = await ReturnInvestmentLpartner.deployed();
      const returnInvest = new web3.eth.Contract(returnInvestmentLpartner.abi, returnInvestmentLpartner.address);

      console.log('******************************************************************************');
      console.log('* ASSET MANAGE CONTRACT                                                      *');
      console.log('******************************************************************************');

      await deployer.deploy(AssetsManageTeam);

      const assetsManageTeam = await AssetsManageTeam.deployed();
      const assetsManage = new web3.eth.Contract(assetsManageTeam.abi, assetsManageTeam.address);

      console.log('******************************************************************************');
      console.log('* POOL REGISTRY                                                              *');
      console.log('******************************************************************************');

      await deployer.deploy(PoolRegistry);

      const poolRegistry = await PoolRegistry.deployed();
      const pool = new web3.eth.Contract(poolRegistry.abi, poolRegistry.address);

      console.log('--------------------------------------------------------------------');
      console.log(`| TEAM ROLES POOL REGISTRY:`);
      console.log('--------------------------------------------------------------------');

      console.log(`Team role                 [${TEAM_ADDRESS}]: ${await pool.methods.isTeam(TEAM_ADDRESS).call()}`);
      await pool.methods.addTeam(TEAM_ADDRESS).send({
        from: accounts[0]
      });
      console.log(`Team role                 [${TEAM_ADDRESS}]: ${await pool.methods.isTeam(TEAM_ADDRESS).call()}`);

      console.log('--------------------------------------------------------------------');

      console.log('--------------------------------------------------------------------');
      console.log(`| Manager role for PoolRegistry in ReturnInvestmentLpartner contract :`);
      console.log('--------------------------------------------------------------------');

      console.log(`Pool Registry Manager     [${poolRegistry.address}]: ${await returnInvest.methods.isManager(poolRegistry.address).call()}`);
      await returnInvest.methods.addManager(poolRegistry.address).send({
        from: accounts[0]
      });
      console.log(`Pool Registry Manager     [${poolRegistry.address}]: ${await returnInvest.methods.isManager(poolRegistry.address).call()}`);

      console.log('--------------------------------------------------------------------');
      console.log(`| Manager role for PoolRegistry in AssetsManageTeam contract :`);
      console.log('--------------------------------------------------------------------');

      console.log(`Pool Registry Manager     [${poolRegistry.address}]: ${await assetsManage.methods.isManager(poolRegistry.address).call()}`);
      await assetsManage.methods.addManager(poolRegistry.address).send({
        from: accounts[0]
      });
      console.log(`Pool Registry Manager     [${poolRegistry.address}]: ${await assetsManage.methods.isManager(poolRegistry.address).call()}`);
      console.log('--------------------------------------------------------------------');

      console.log('--------------------------------------------------------------------');
      console.log(`| AssetsManageTeam contract address:`);
      console.log('--------------------------------------------------------------------');

      console.log(`AssetsManageTeam contract     [${accounts[0]}]: ${await pool.methods.getAssetManageTeamContract().call()}`);
      await pool.methods.setAssetManageTeamContract(assetsManageTeam.address).send({
        from: accounts[0]
      });
      console.log(`AssetsManageTeam contract     [${accounts[0]}]: ${await pool.methods.getAssetManageTeamContract().call()}`);

      console.log('--------------------------------------------------------------------');
      console.log(`| ReturnInvestmentLpartner contract address:`);
      console.log('--------------------------------------------------------------------');

      console.log(`ReturnInvestmentLpartner contract     [${accounts[0]}]: ${await pool.methods.getReturnInvesmentLpartner().call()}`);
      await pool.methods.setReturnInvestmentLpartner(returnInvestmentLpartner.address).send({
        from: accounts[0]
      });
      console.log(`ReturnInvestmentLpartner contract     [${accounts[0]}]: ${await pool.methods.getReturnInvesmentLpartner().call()}`);

      console.log('--------------------------------------------------------------------');

      await deployer.deploy(ReturnInvestmentLpartner);

      console.log('--------------------------------------------------------------------');

      console.log('******************************************************************************');
      console.log('* ORACLE CONTRACT                                                            *');
      console.log('******************************************************************************');

      await deployer.deploy(Oracle);
      const oracle = await Oracle.deployed();

      console.log('******************************************************************************');
      console.log('* CALCULATE WITHDRAW INVESTMENT                                              *');
      console.log('******************************************************************************');

      await deployer.deploy(CalculateWithdrawEth);
      const calculateWithdraw = await CalculateWithdrawEth.deployed();
      const calculate = new web3.eth.Contract(calculateWithdraw.abi, calculateWithdraw.address);
      
      await calculate.methods.setOracle(oracle.address).send({
        from: accounts[0]
      });

      console.log('--------------------------------------------------------------------');
      console.log(`| Manager role for Team Account in Calculate Withdraw eth contract :`);
      console.log('--------------------------------------------------------------------');

      console.log(`Pool Registry Manager     [${TEAM_ADDRESS}]: ${await calculate.methods.isManager(TEAM_ADDRESS).call()}`);
      await calculate.methods.addManager(TEAM_ADDRESS).send({
        from: accounts[0]
      });
      console.log(`Pool Registry Manager     [${TEAM_ADDRESS}]: ${await calculate.methods.isManager(TEAM_ADDRESS).call()}`);


      console.log('******************************************************************************');
      console.log('* CREATOR INVESTMENT POOL                                                    *');
      console.log('******************************************************************************');

      await deployer.deploy(CreatorInvestmentPool, poolRegistry.address, assetsManageTeam.address, returnInvestmentLpartner.address, calculateWithdraw.address);

      const creatorInvestmentPool = await CreatorInvestmentPool.deployed();

      console.log('--------------------------------------------------------------------');
      console.log(`| Admin roles for CreatorInvestPool in AssetsManageTeam contract:`);
      console.log('--------------------------------------------------------------------');

      console.log(`Pool Registry Manager     [${creatorInvestmentPool.address}]: ${await assetsManage.methods.isManager(creatorInvestmentPool.address).call()}`);
      await assetsManage.methods.addManager(creatorInvestmentPool.address).send({
        from: accounts[0]
      });
      console.log(`Pool Registry Manager     [${creatorInvestmentPool.address}]: ${await assetsManage.methods.isManager(creatorInvestmentPool.address).call()}`);

      console.log('--------------------------------------------------------------------');

      console.log(`CreatorInvestmentPool address: ${await pool.methods.getAddressCreatorInvestPool().call()}`);
      await pool.methods.setAddressCreatorInvestPool(creatorInvestmentPool.address).send({
        from: accounts[0]
      });
      console.log(`CreatorInvestmentPool address: ${await pool.methods.getAddressCreatorInvestPool().call()}`);

      console.log('--------------------------------------------------------------------');

      // console.log(`Deployer general partner:      ${await pool.methods.hasRole(GENERAL_PARTNER_ROLE, accounts[0]).call()}`);
      // await pool.methods.renounceRole(GENERAL_PARTNER_ROLE, accounts[0]).send({ from: accounts[0] });
      // console.log(`Deployer general partner:      ${await pool.methods.hasRole(GENERAL_PARTNER_ROLE, accounts[0]).call()}`);

      // console.log(`Deployer contract isAdmin:   ${await pool.methods.hasRole(SUPER_ADMIN_ROLE, accounts[0]).call()}`);
      // await pool.methods.renounceRole(SUPER_ADMIN_ROLE, accounts[0]).send({ from: accounts[0] });
      // console.log(`Deployer contract isAdmin:   ${await pool.methods.hasRole(SUPER_ADMIN_ROLE, accounts[0]).call()}`);

      // await pool.methods.finalize().send({ from: accounts[0] });

      // console.log(`Deployer contract isAdmin:   ${await pool.methods.hasRole(SUPER_ADMIN_ROLE, accounts[0]).call()}`);
      // await pool.methods.renounceRole(SUPER_ADMIN_ROLE, accounts[0]).send({ from: accounts[0] });
      // console.log(`Deployer contract isAdmin:   ${await pool.methods.hasRole(SUPER_ADMIN_ROLE, accounts[0]).call()}`);

      // await pool.methods.finalize().send({ from: accounts[0] });

    } catch (error) {
      console.log("| Deploy error!");
      console.log(error);
    }
  });
};