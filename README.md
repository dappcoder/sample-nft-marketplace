## Simple NFT Matketplace
Demo project for Cluj Ethereum Summer School.

### Prerequisites
We are using foundry as a development environment that uses Rust compiler and package manager.

#### Install Rust
```
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
```

#### Install Foundry
```
curl -L https://foundry.paradigm.xyz | bash
```

#### Build

```shell
$ forge build
```

#### Test

```shell
$ forge test
```

#### Deploy

For deployment we first need to setup the deployer account with native coin funds on it and to set the RPC url (the node address through which our script accesses the blockchain network).

1. Create a .env file in the root of your project directory.

2. Add your private key and RPC URL to the .env file:
```
PRIVATE_KEY=your_private_key
RPC_URL=your_rpc_url
```

Replace your_private_key with the private key of the deployer account and your_rpc_url with the URL of your Ethereum node (e.g., Infura, Alchemy).

```shell
forge script script/DeployNFTMarketplace.s.sol --rpc-url $RPC_URL --private-key $PRIVATE_KEY --broadcast
```

After running the script, you should see the deployed contract addresses logged in the console. You can verify the deployment on an Ethereum block explorer like Etherscan by searching for the contract addresses.
