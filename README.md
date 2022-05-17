### Overview
---
* pool* full version.

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
truffle run verify InvestmentPool --network kovan
```

#### Deployment summary:
---
### Ropsten

```bash
Starting migrations...
======================
> Network name:    'ropsten'
> Network id:      3
> Block gas limit: 8000000 (0x7a1200)


1_deploy_contracts.js
=====================
--------------------------------------------------------------------------------------------
| Network: ropsten / deployer: 0x3A39155F08989f4639f156992F02c744Dc6Cf5E1 | Balance: 2.495212285773470031 ETH
|----------------------------------------------------------
 Super admin address 0x01d49981D60766dA64949aeEc0821b60458cbA6b
 Balance 0.830970304111058385 ETH
|----------------------------------------------------------
 General partner address second 0x01d49981D60766dA64949aeEc0821b60458cbA6b
 Balance 0.830970304111058385 ETH
|----------------------------------------------------------
 Limited partner address third 0x16FFC9a18aEb44462579cF33a1b9A3E95A1a177C
 Balance 0.199475 ETH
|----------------------------------------------------------
 Team address 0xBf239dB73992efEC239eF69c8416255a8422795D
 Balance 0 ETH
|----------------------------------------------------------
 Sturtap team address 0xc30A469379b772dF065F6f52DF89B3FB50E46617
 Balance 0 ETH
|----------------------------------------------------------
 Referer address 0xBf239dB73992efEC239eF69c8416255a8422795D
 Balance 0 ETH
|----------------------------------------------------------

   Deploying 'InvestmentPool'
   --------------------------
   > transaction hash:    0x5ac05c91db04fc850ac610f02e63ebcd5d051d3b425c880299e6d85d8ecb6d78
   > Blocks: 2            Seconds: 5
   > contract address:    0xD88400d4Ac8EA9e2d9d5f03D44EfE0c41fEedEA3
   > block number:        9216021
   > block timestamp:     1607365147
   > account:             0x3A39155F08989f4639f156992F02c744Dc6Cf5E1
   > balance:             2.309305585773470031
   > gas used:            3098445 (0x2f474d)
   > gas price:           60 gwei
   > value sent:          0 ETH
   > total cost:          0.1859067 ETH

   Pausing for 2 confirmations...
   ------------------------------
   > confirmation number: 1 (block: 9216022)
   > confirmation number: 2 (block: 9216023)
--------------------------------------------------------------------
--------------------------------------------------------------------
Investment Pool address:   0xD88400d4Ac8EA9e2d9d5f03D44EfE0c41fEedEA3
Token address:             0x53EbA072CB9Ff76Ba50BbfcCd1cd6B762A46dA52
Locked:                    123456789
Rate:                      2000000000000
Interest fee:              10
Anual precent:             700
--------------------------------------------------------------------
--------------------------------------------------------------------
Deployer contract isAdmin:   true
Deployer contract isAdmin:   false
   > Saving artifacts
   -------------------------------------
   > Total cost:           0.1859067 ETH


Summary
=======
> Total deployments:   1
> Final cost:          0.1859067 ETH
```
