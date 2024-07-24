// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract NFTMarketplace is Ownable {
    struct Listing {
        address seller;
        address erc721;
        uint256 tokenId;
        address erc20;
        uint256 price;
    }

    mapping(uint256 => Listing) public listings;
    uint256 public listingCount;

    event NFTListed(uint256 listingId, address indexed seller, address indexed erc721, uint256 indexed tokenId, address erc20, uint256 price);
    event NFTBought(uint256 listingId, address indexed buyer, address indexed erc721, uint256 indexed tokenId);

    constructor(address initialOwner) Ownable(initialOwner) {
        // Initial owner set through Ownable constructor
    }

    function listNFT(address _erc721, uint256 _tokenId, address _erc20, uint256 _price) external {
        IERC721(_erc721).transferFrom(msg.sender, address(this), _tokenId);

        listings[listingCount] = Listing({
            seller: msg.sender,
            erc721: _erc721,
            tokenId: _tokenId,
            erc20: _erc20,
            price: _price
        });

        emit NFTListed(listingCount, msg.sender, _erc721, _tokenId, _erc20, _price);

        listingCount++;
    }

    function buyNFT(uint256 _listingId) external {
        Listing storage listing = listings[_listingId];

        require(listing.price > 0, "Listing does not exist");
        require(IERC20(listing.erc20).transferFrom(msg.sender, listing.seller, listing.price), "Payment failed");

        IERC721(listing.erc721).transferFrom(address(this), msg.sender, listing.tokenId);

        emit NFTBought(_listingId, msg.sender, listing.erc721, listing.tokenId);

        delete listings[_listingId];
    }

    function cancelListing(uint256 _listingId) external {
        Listing storage listing = listings[_listingId];

        require(listing.seller == msg.sender, "Only seller can cancel listing");

        IERC721(listing.erc721).transferFrom(address(this), msg.sender, listing.tokenId);

        delete listings[_listingId];
    }
}
