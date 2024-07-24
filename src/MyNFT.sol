// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract MyNFT is ERC721, Ownable {
    uint256 private _currentTokenId;

    constructor(address initialOwner) ERC721("MyNFT", "MNFT") Ownable(initialOwner) {
        _currentTokenId = 0;
    }

    function mint(address to) external onlyOwner returns (uint256) {
        _currentTokenId += 1;
        uint256 newItemId = _currentTokenId;
        _mint(to, newItemId);
        return newItemId;
    }
}
