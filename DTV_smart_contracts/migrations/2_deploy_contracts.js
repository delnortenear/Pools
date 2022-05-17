const HDWalletProvider = require("@truffle/hdwallet-provider");
const mnemonic = "pass vital mad start beauty lonely feed able maid permit retire fire";
const Web3 = require("web3");

const TRUFFLE_PRIVATE_KEY = "0xDaf572525c13A08A27f1BA67e06263AA658D920C";
const MANAGER_ADDRESS = "0xDaf572525c13A08A27f1BA67e06263AA658D920C";
const WALLET_ADDRESS = "0xDaf572525c13A08A27f1BA67e06263AA658D920C";
const MINTER_ADDRESS = "0xDaf572525c13A08A27f1BA67e06263AA658D920C";
const ADMIN_ADDRESS_FIRST = "0xDaf572525c13A08A27f1BA67e06263AA658D920C";
const ADMIN_ADDRESS_SECOND = "0xDaf572525c13A08A27f1BA67e06263AA658D920C";
const ADMIN_ADDRESS_THIRD = "0xDaf572525c13A08A27f1BA67e06263AA658D920C";
const ADDRESS_POOL = "0xDaf572525c13A08A27f1BA67e06263AA658D920C";

console.log(TRUFFLE_PRIVATE_KEY);
const provider = new HDWalletProvider(
  mnemonic,
  `https://ropsten.infura.io/v3/89e41def87784184831bc5ba6f69dd20`
);

const web3 = new Web3(provider);

const DELAY = 5;

const MANAGER_ADMIN_ROLE = web3.utils.sha3("MANAGER_ADMIN_ROLE");
const MANAGER_ROLE = web3.utils.sha3("MANAGER_ROLE");
const MINTER_ADMIN_ROLE = web3.utils.sha3("MINTER_ADMIN_ROLE");
const MINTER_ROLE = web3.utils.sha3("MINTER_ROLE");

const CONTRACT_ADDR = "0x5A36b764DE26e4B7FdfF00a3DD43D28449193d76";
const abicode = [{"inputs":[],"stateMutability":"nonpayable","type":"constructor"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"owner","type":"address"},{"indexed":true,"internalType":"address","name":"spender","type":"address"},{"indexed":false,"internalType":"uint256","name":"value","type":"uint256"}],"name":"Approval","type":"event"},{"anonymous":false,"inputs":[],"name":"Finalized","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"previousOwner","type":"address"},{"indexed":true,"internalType":"address","name":"newOwner","type":"address"}],"name":"OwnershipTransferred","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"internalType":"address","name":"account","type":"address"}],"name":"Paused","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"bytes32","name":"role","type":"bytes32"},{"indexed":true,"internalType":"address","name":"account","type":"address"},{"indexed":true,"internalType":"address","name":"sender","type":"address"}],"name":"RoleGranted","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"bytes32","name":"role","type":"bytes32"},{"indexed":true,"internalType":"address","name":"account","type":"address"},{"indexed":true,"internalType":"address","name":"sender","type":"address"}],"name":"RoleRevoked","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"from","type":"address"},{"indexed":true,"internalType":"address","name":"to","type":"address"},{"indexed":false,"internalType":"uint256","name":"value","type":"uint256"}],"name":"Transfer","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"internalType":"address","name":"account","type":"address"}],"name":"Unpaused","type":"event"},{"inputs":[],"name":"DEFAULT_ADMIN_ROLE","outputs":[{"internalType":"bytes32","name":"","type":"bytes32"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"MINTER_ADMIN_ROLE","outputs":[{"internalType":"bytes32","name":"","type":"bytes32"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"MINTER_ROLE","outputs":[{"internalType":"bytes32","name":"","type":"bytes32"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"bytes32","name":"role","type":"bytes32"},{"internalType":"address","name":"account","type":"address"}],"name":"addAdmin","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address","name":"owner","type":"address"},{"internalType":"address","name":"spender","type":"address"}],"name":"allowance","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"address","name":"spender","type":"address"},{"internalType":"uint256","name":"amount","type":"uint256"}],"name":"approve","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address","name":"account","type":"address"}],"name":"balanceOf","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"cap","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"decimals","outputs":[{"internalType":"uint8","name":"","type":"uint8"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"address","name":"spender","type":"address"},{"internalType":"uint256","name":"subtractedValue","type":"uint256"}],"name":"decreaseAllowance","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"nonpayable","type":"function"},{"inputs":[],"name":"finalize","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"bytes32","name":"role","type":"bytes32"}],"name":"getRoleAdmin","outputs":[{"internalType":"bytes32","name":"","type":"bytes32"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"bytes32","name":"role","type":"bytes32"},{"internalType":"uint256","name":"index","type":"uint256"}],"name":"getRoleMember","outputs":[{"internalType":"address","name":"","type":"address"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"bytes32","name":"role","type":"bytes32"}],"name":"getRoleMemberCount","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"bytes32","name":"role","type":"bytes32"},{"internalType":"address","name":"account","type":"address"}],"name":"grantRole","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"bytes32","name":"role","type":"bytes32"},{"internalType":"address","name":"account","type":"address"}],"name":"hasRole","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"address","name":"spender","type":"address"},{"internalType":"uint256","name":"addedValue","type":"uint256"}],"name":"increaseAllowance","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address","name":"to","type":"address"},{"internalType":"uint256","name":"amount","type":"uint256"}],"name":"mint","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"nonpayable","type":"function"},{"inputs":[],"name":"name","outputs":[{"internalType":"string","name":"","type":"string"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"owner","outputs":[{"internalType":"address","name":"","type":"address"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"paused","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"renounceOwnership","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"bytes32","name":"role","type":"bytes32"},{"internalType":"address","name":"account","type":"address"}],"name":"renounceRole","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"bytes32","name":"role","type":"bytes32"},{"internalType":"address","name":"account","type":"address"}],"name":"revokeRole","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[],"name":"symbol","outputs":[{"internalType":"string","name":"","type":"string"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"totalSupply","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"address","name":"to","type":"address"},{"internalType":"uint256","name":"amount","type":"uint256"}],"name":"transfer","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address","name":"sender","type":"address"},{"internalType":"address","name":"recipient","type":"address"},{"internalType":"uint256","name":"amount","type":"uint256"}],"name":"transferFrom","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address","name":"newOwner","type":"address"}],"name":"transferOwnership","outputs":[],"stateMutability":"nonpayable","type":"function"}];

//const Dtoken = artifacts.require("Stars");
const DelnorteSwap = artifacts.require("StarsSwap");

module.exports = function (deployer, network, accounts) {
  deployer.then(async () => {
    console.log(accounts)
    try {
      console.log('--------------------------------------------------------------------------------------------');

      const balanceDeployerStart = web3.utils.fromWei(await web3.eth.getBalance(accounts[0]), 'ether');
      console.log(`| Network: ${network} / deployer: ${accounts[0]} | Balance: ${balanceDeployerStart} ETH`);

      console.log(`|----------------------------------------------------------`);
      console.log(` Admin address first ${ADMIN_ADDRESS_FIRST}`);
      console.log(` Balance ${web3.utils.fromWei(await web3.eth.getBalance(ADMIN_ADDRESS_FIRST), 'ether')} ETH`);
      console.log(`|----------------------------------------------------------`);
      console.log(` Admin address second ${ADMIN_ADDRESS_SECOND}`);
      console.log(` Balance ${web3.utils.fromWei(await web3.eth.getBalance(ADMIN_ADDRESS_SECOND), 'ether')} ETH`);
      console.log(`|----------------------------------------------------------`);
      console.log(` Admin address third ${ADMIN_ADDRESS_THIRD}`);
      console.log(` Balance ${web3.utils.fromWei(await web3.eth.getBalance(ADMIN_ADDRESS_THIRD), 'ether')} ETH`);
      console.log(`|----------------------------------------------------------`);
      console.log(` Manager address ${MANAGER_ADDRESS}`);
      console.log(` Balance ${web3.utils.fromWei(await web3.eth.getBalance(MANAGER_ADDRESS), 'ether')} ETH`);
      console.log(`|----------------------------------------------------------`);


      
      const token = new web3.eth.Contract(abicode, CONTRACT_ADDR);
    

      await deployer.deploy(DelnorteSwap, WALLET_ADDRESS, '0x5A36b764DE26e4B7FdfF00a3DD43D28449193d76');

       console.log('----------------------------------------------------------');
      console.log(`Miner Admin Role deployer     [${MANAGER_ADDRESS}]: ${await token.methods.hasRole(MINTER_ADMIN_ROLE, MANAGER_ADDRESS).call()}`);
      await token.methods.addAdmin(MINTER_ADMIN_ROLE, accounts[0]).send({
        from: accounts[0]
      });
      console.log(`Miner Admin Role deployer     [${MANAGER_ADDRESS}]: ${await token.methods.hasRole(MINTER_ADMIN_ROLE, MANAGER_ADDRESS).call()}`);
      console.log('----------------------------------------------------------');

      console.log(`Minter role deployer    [${MANAGER_ADDRESS}]: ${await token.methods.hasRole(MINTER_ROLE, MANAGER_ADDRESS).call()}`);
      await token.methods.grantRole(MINTER_ROLE, MANAGER_ADDRESS).send({
        from: accounts[0]
      });
      console.log(`Minter role deployer    [${MANAGER_ADDRESS}]: ${await token.methods.hasRole(MINTER_ROLE, MANAGER_ADDRESS).call()}`);

      console.log('----------------------------------------------------------');

      console.log('----------------------------------------------------------');
      console.log(await token.methods.symbol().call());
      console.log(`Cap: ${(await token.methods.cap().call()) / (10 ** await token.methods.decimals().call())}`);
      console.log(`Total supply: ${await token.methods.totalSupply().call()}`);
      console.log(`Minter: ${await token.methods.hasRole(MINTER_ADMIN_ROLE, MANAGER_ADDRESS).call()} <= minter admin role`);
      console.log(`Minter: ${await token.methods.hasRole(MINTER_ROLE, MANAGER_ADDRESS).call()} <= minter role`);
      console.log('==========================================================\n');


      const balanceDeployerEnd = web3.utils.fromWei(await web3.eth.getBalance(accounts[0]), 'ether');
      console.log(`| Network: ${network} / deployer: ${accounts[0]} | Balance: ${balanceDeployerEnd} ETH`);

      return;

    } catch (error) {
      console.log("| Deploy error!");
      console.log(error);
    }
  });
};

function delay(_DELAY = DELAY) {
  return new Promise((resolve, reject) => {
    console.log(`    | Waiting for ${_DELAY} sec...`);
    setTimeout(() => {
      resolve(`Time is up`);
    }, _DELAY * 1000);
  })
}
