// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155URIStorage.sol";

contract Token3 is ERC1155URIStorage {
    uint256 public tokenCounter = 0;
    uint256 public pricePerToken = 0.01 ether;

    constructor() ERC1155("") {
    }

    /// @notice ERC1155 Transaction
    function buyToken(uint256 amount, string memory tokenURI) public payable {
        require(msg.value >= pricePerToken * amount, "Not enought ether");
        _mint(msg.sender, tokenCounter, amount, "");
        _setURI(tokenCounter, tokenURI);
        tokenCounter++;
    }
}