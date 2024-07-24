// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {NFTMarketplace} from "../src/NFTMarketplace.sol";
import {MyToken} from "../src/MyToken.sol";
import {MyNFT} from "../src/MyNFT.sol";

contract DeployNFTMarketplace is Script {
    function setUp() public {}

    function run() public {
        // Derive deployer address from private key
        address deployer = vm.addr(vm.envUint("PRIVATE_KEY"));

        vm.startBroadcast(deployer);

        // Deploy MyToken with an initial supply of 1,000,000 tokens
        MyToken myToken = new MyToken(1000000 * (10 ** 18));
        console.log("MyToken deployed at:", address(myToken));

        // Deploy MyNFT with the deployer as the initial owner
        MyNFT myNFT = new MyNFT(deployer);
        console.log("MyNFT deployed at:", address(myNFT));

        // Deploy NFTMarketplace with the deployer as the initial owner
        NFTMarketplace marketplace = new NFTMarketplace(deployer);
        console.log("NFTMarketplace deployed at:", address(marketplace));

        vm.stopBroadcast();
    }
}