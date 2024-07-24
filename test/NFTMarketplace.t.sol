// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../src/NFTMarketplace.sol";
import "../src/MyToken.sol";
import "../src/MyNFT.sol";

contract NFTMarketplaceTest is Test {
    MyToken private myToken;
    MyNFT private myNFT;
    NFTMarketplace private marketplace;
    address private seller;
    address private buyer;

    function setUp() public {
        seller = address(0x123);
        buyer = address(0x456);

        // Deploy MyToken with an initial supply of 1,000,000 tokens
        myToken = new MyToken(1000000 * (10 ** 18));

        // Distribute tokens to buyer
        myToken.transfer(buyer, 1000 * (10 ** 18));

        // Deploy MyNFT
        myNFT = new MyNFT(seller);

        // Deploy NFTMarketplace
        marketplace = new NFTMarketplace(seller);

        // Mint an NFT to the seller
        vm.prank(seller);
        myNFT.mint(seller);
    }

    function testListAndBuyNFT() public {
        uint256 tokenId = 1;
        uint256 price = 100 * (10 ** 18); // 100 tokens

        // Seller approves the marketplace to transfer the NFT
        vm.prank(seller);
        myNFT.approve(address(marketplace), tokenId);

        // Seller lists the NFT on the marketplace
        vm.prank(seller);
        marketplace.listNFT(address(myNFT), tokenId, address(myToken), price);

        // Verify the listing details
        (address sellerAddress, address erc721, uint256 id, address erc20, uint256 listingPrice) = marketplace.listings(0);
        assertEq(sellerAddress, seller);
        assertEq(erc721, address(myNFT));
        assertEq(id, tokenId);
        assertEq(erc20, address(myToken));
        assertEq(listingPrice, price);

        // Buyer approves the marketplace to transfer the ERC20 tokens
        vm.prank(buyer);
        myToken.approve(address(marketplace), price);

        // Buyer buys the NFT
        vm.prank(buyer);
        marketplace.buyNFT(0);

        // Verify the NFT ownership has changed
        assertEq(myNFT.ownerOf(tokenId), buyer);

        // Verify the ERC20 token balance has changed
        assertEq(myToken.balanceOf(seller), price);
        assertEq(myToken.balanceOf(buyer), 900 * (10 ** 18));
    }
}
