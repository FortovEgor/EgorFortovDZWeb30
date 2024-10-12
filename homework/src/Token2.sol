// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

contract Token2 is ERC721URIStorage {
    uint256 public tokenCounter;
    uint256 public pricePerNFT = 0.01 ether;

    constructor() ERC721("FreakNFT", "FRNFT") {
        tokenCounter = 0;
    }

    /// @notice Buy NFT
    function buyToken(string memory tokenURI) public payable {
        require(msg.value >= pricePerNFT, "Not enought ether to buy");
        _safeMint(msg.sender, tokenCounter);
        _setTokenURI(tokenCounter, tokenURI);
        tokenCounter++;
    }
}