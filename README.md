# ChessCombo Cadence

Testnet application is deployed to: https://testnet.chesscombo.com/ 

Initial slowness is due to nodes being asleep so be patient!

[![](https://testnet.chesscombo.com/logo192.png)](https://testnet.chesscombo.com/logo192.png) 

This repo contains foundational contracts for ChessCombo platform. The main contract, ChessCombo, is entirely analogous to [NBA TopShot contract.](https://github.com/dapperlabs/nba-smart-contracts "NBA TopShot contract.")

The Storefront contract is almost identical to [NFTStorefront contract from kitty-items.](https://github.com/onflow/kitty-items/blob/master/cadence/contracts/NFTStorefront.cdc "NFTStorefront contract from kitty-items.")

Repo contains one original contract, used for managing pack additions and pack buys - [PackDropper.cdc](https://github.com/milosponj/chess-combo-cadence/blob/master/contracts/PackDropper.cdc "PackDropper.cdc")

All contracts on testnet are deployed to: `0x5a2c15468a922d26`


| Name  |Source   | Address |
| ------------ | ------------ | ------------ | 
| ChessCombo.cdc  | dapperlabs  | https://github.com/milosponj/chess-combo-cadence/blob/master/contracts/ChessCombo.cdc |
| FUSD.cdc  | Official Contract  |
| FungibleToken.cdc  | Core Contract  |
| NFTStorefront.cdc  | Kitty Items   | https://github.com/onflow/kitty-items/blob/master/cadence/contracts/NFTStorefront.cdc|
| NonFungibleToken.cdc  | Core Contract  |
| PackDropper.cdc  | **Original** contract  | https://github.com/milosponj/chess-combo-cadence/blob/master/contracts/PackDropper.cdc |

### Additional info

- Tests are failing only in CI, but work locally. Related issue: https://github.com/onflow/flow-js-testing/issues/47
- Application is deployed to Azure
- This repo is only concerned with the contracts deployed to flow (middle part of the image below)

[Top level architecture](.github\top-level-architecture.jpg)

### Running tests

`cd test`
`npm run test`

### Process for creating a new test account

1. First generate new keys

```sh
flow keys generate
```

2. Go to https://testnet-faucet-v2.onflow.org/?
3. Paste in the public key
4. Copy over the address generated on the web page to the flow.json

### Deploy to testnet

Run this command:

```sh
flow project deploy --network=testnet
```
