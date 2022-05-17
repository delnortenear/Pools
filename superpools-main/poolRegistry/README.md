### Overview
---
*Pool Registry*

### Run
---
```bash

$ npm install

NOTE: Edit .env.blank add TRUFFLE_PRIVATE_KEY, change addresses roles

# Kovan env
$ . .env.blank && truffle console --network kovan
# Ropsten env
$ . .env.blank && truffle console --network ropsten
# or
$ . .env.blank && truffle console --network mainnet

> migrate --reset
```

*VERIFY ETHERSCAN*
```bash
truffle run verify PoolRegistry --network kovan
```

*Get size contracts*
```bash
truffle run contract-size
```

#### Deployment summary:
---
### Ropsten

```bash
Compiling your contracts...
===========================
> Everything is up to date, there is nothing to compile.



Starting migrations...
======================
> Network name:    'kovan'
> Network id:      42
> Block gas limit: 12499988 (0xbebc14)


1_deploy_contracts.js
=====================
--------------------------------------------------------------------------------------------
| Network: kovan / deployer: 0x3A39155F08989f4639f156992F02c744Dc6Cf5E1 | Balance: 7.627772980170915894 ETH
|----------------------------------------------------------
 Team role pool registry address       0x6ADdA3169008Ea8A5B201CE98Bd66DED97ec6bef
 Balance 0.250793482 ETH
|----------------------------------------------------------
******************************************************************************
* RETURN INVESTMENT LIMITED PARTNER CONTRACT                                 *
******************************************************************************

   Replacing 'ReturnInvestmentLpartner'
   ------------------------------------
   > transaction hash:    0xe5e678059150a1f710b8b98f54ad798a9297872532396f6f2c943c98be093469
   > Blocks: 2            Seconds: 13
   > contract address:    0x033C8Af490bA96A7c3259c0C0857a3BBade8Fa11
   > block number:        23195515
   > block timestamp:     1611842588
   > account:             0x3A39155F08989f4639f156992F02c744Dc6Cf5E1
   > balance:             7.538563980170915894
   > gas used:            2230225 (0x2207d1)
   > gas price:           40 gwei
   > value sent:          0 ETH
   > total cost:          0.089209 ETH

   Pausing for 2 confirmations...
   ------------------------------
   > confirmation number: 1 (block: 23195516)
   > confirmation number: 2 (block: 23195517)
******************************************************************************
* ASSET MANAGE CONTRACT                                                      *
******************************************************************************

   Replacing 'AssetsManageTeam'
   ----------------------------
   > transaction hash:    0x71dd747747dfc2d5b7b40ccec1068f92c7bb8ff948796c188f6226f15c94077f
   > Blocks: 2            Seconds: 13
   > contract address:    0x884C7f2D77483dF3A1463C80cfDA0ECaeE3811a8
   > block number:        23195521
   > block timestamp:     1611842620
   > account:             0x3A39155F08989f4639f156992F02c744Dc6Cf5E1
   > balance:             7.358218500170915894
   > gas used:            4508637 (0x44cbdd)
   > gas price:           40 gwei
   > value sent:          0 ETH
   > total cost:          0.18034548 ETH

   Pausing for 2 confirmations...
   ------------------------------
   > confirmation number: 1 (block: 23195523)
   > confirmation number: 3 (block: 23195525)
******************************************************************************
* POOL REGISTRY                                                              *
******************************************************************************

   Replacing 'PoolRegistry'
   ------------------------
   > transaction hash:    0xf04cd88d864c899cde7c006f37391ca4e60a2c68ffae0859ac74c10bee8025f0
   > Blocks: 1            Seconds: 5
   > contract address:    0x4E85fFd4e661dB65DCAF035D1c40683C64B2F4B9
   > block number:        23195527
   > block timestamp:     1611842652
   > account:             0x3A39155F08989f4639f156992F02c744Dc6Cf5E1
   > balance:             7.164771140170915894
   > gas used:            4836184 (0x49cb58)
   > gas price:           40 gwei
   > value sent:          0 ETH
   > total cost:          0.19344736 ETH

   Pausing for 2 confirmations...
   ------------------------------
   > confirmation number: 1 (block: 23195529)
   > confirmation number: 2 (block: 23195530)
--------------------------------------------------------------------
| TEAM ROLES POOL REGISTRY:
--------------------------------------------------------------------
Team role                 [0x6ADdA3169008Ea8A5B201CE98Bd66DED97ec6bef]: false
Team role                 [0x6ADdA3169008Ea8A5B201CE98Bd66DED97ec6bef]: true
--------------------------------------------------------------------
--------------------------------------------------------------------
| Manager role for PoolRegistry in ReturnInvestmentLpartner contract :
--------------------------------------------------------------------
Pool Registry Manager     [0x4E85fFd4e661dB65DCAF035D1c40683C64B2F4B9]: false
Pool Registry Manager     [0x4E85fFd4e661dB65DCAF035D1c40683C64B2F4B9]: true
--------------------------------------------------------------------
| Manager role for PoolRegistry in AssetsManageTeam contract :
--------------------------------------------------------------------
Pool Registry Manager     [0x4E85fFd4e661dB65DCAF035D1c40683C64B2F4B9]: false
Pool Registry Manager     [0x4E85fFd4e661dB65DCAF035D1c40683C64B2F4B9]: true
--------------------------------------------------------------------
--------------------------------------------------------------------
| AssetsManageTeam contract address:
--------------------------------------------------------------------
AssetsManageTeam contract     [0x3A39155F08989f4639f156992F02c744Dc6Cf5E1]: 0x0000000000000000000000000000000000000000
AssetsManageTeam contract     [0x3A39155F08989f4639f156992F02c744Dc6Cf5E1]: 0x884C7f2D77483dF3A1463C80cfDA0ECaeE3811a8
--------------------------------------------------------------------
| ReturnInvestmentLpartner contract address:
--------------------------------------------------------------------
ReturnInvestmentLpartner contract     [0x3A39155F08989f4639f156992F02c744Dc6Cf5E1]: 0x0000000000000000000000000000000000000000
ReturnInvestmentLpartner contract     [0x3A39155F08989f4639f156992F02c744Dc6Cf5E1]: 0x033C8Af490bA96A7c3259c0C0857a3BBade8Fa11
--------------------------------------------------------------------

   Replacing 'ReturnInvestmentLpartner'
   ------------------------------------
   > transaction hash:    0x0aeab6b5067e904751333a7cbe67815943f7344d06479faa02d553c60130bcbe
   > Blocks: 1            Seconds: 5
   > contract address:    0xc5D4Fdf3fBD0AB6658149CC2991322Dfef2877B8
   > block number:        23195543
   > block timestamp:     1611842736
   > account:             0x3A39155F08989f4639f156992F02c744Dc6Cf5E1
   > balance:             7.074827118570915894
   > gas used:            2230225 (0x2207d1)
   > gas price:           40 gwei
   > value sent:          0 ETH
   > total cost:          0.089209 ETH

   Pausing for 2 confirmations...
   ------------------------------
   > confirmation number: 1 (block: 23195545)
   > confirmation number: 2 (block: 23195546)
******************************************************************************
* CALCULATE WITHDRAW INVESTMENT                                              *
******************************************************************************

   Replacing 'CalculateWithdrawEth'
   --------------------------------
   > transaction hash:    0x5e22d7e28ff63edcb9f5fe602a6539e8e26f563447357eccdcc986dac5fd668b
   > Blocks: 1            Seconds: 6
   > contract address:    0x361cc44A35aB992Eab7448e1Cb1c88D4680a9fa0
   > block number:        23195548
   > block timestamp:     1611842764
   > account:             0x3A39155F08989f4639f156992F02c744Dc6Cf5E1
   > balance:             7.033709638570915894
   > gas used:            1027937 (0xfaf61)
   > gas price:           40 gwei
   > value sent:          0 ETH
   > total cost:          0.04111748 ETH

   Pausing for 2 confirmations...
   ------------------------------
   > confirmation number: 2 (block: 23195550)
******************************************************************************
* CREATOR INVESTMENT POOL                                                    *
******************************************************************************

   Replacing 'CreatorInvestmentPool'
   ---------------------------------
   > transaction hash:    0x0b183a1c0ea348e558b481acc73e02f8d872b05d6c6f5a5cd9e77555b0bc7ec8
   > Blocks: 2            Seconds: 9
   > contract address:    0x692EE384EC200d179eAe4f5A26546B06ac42270a
   > block number:        23195552
   > block timestamp:     1611842784
   > account:             0x3A39155F08989f4639f156992F02c744Dc6Cf5E1
   > balance:             6.818999718570915894
   > gas used:            5367748 (0x51e7c4)
   > gas price:           40 gwei
   > value sent:          0 ETH
   > total cost:          0.21470992 ETH

   Pausing for 2 confirmations...
   ------------------------------
   > confirmation number: 1 (block: 23195554)
   > confirmation number: 2 (block: 23195555)
--------------------------------------------------------------------
| Admin roles for CreatorInvestPool in AssetsManageTeam contract:
--------------------------------------------------------------------
Pool Registry Manager     [0x692EE384EC200d179eAe4f5A26546B06ac42270a]: false
Pool Registry Manager     [0x692EE384EC200d179eAe4f5A26546B06ac42270a]: true
--------------------------------------------------------------------
CreatorInvestmentPool address: 0x0000000000000000000000000000000000000000
CreatorInvestmentPool address: 0x692EE384EC200d179eAe4f5A26546B06ac42270a
--------------------------------------------------------------------
   > Saving artifacts
   -------------------------------------
   > Total cost:          0.80803824 ETH


Summary
=======
> Total deployments:   6
> Final cost:          0.80803824 ETH
```
