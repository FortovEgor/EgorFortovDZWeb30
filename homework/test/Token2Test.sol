// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.12;

import "forge-std/Test.sol";
import "../src/TokenTwo.sol";

contract TokenTwoTest is Test {
    TokenTwo public nftContract;
    address public buyer;


    uint256 public price = 0.01 ether;
    string public tkIPFS1 = "ipfs://tk1";
    string public tkIPFS2 = "ipfs://tk2";

    function setUp() public {
        nftContract = new TokenTwo();
        buyer = vm.addr(0x1);
        vm.deal(buyer, 1 ether);
    }

    /// @notice Buy token test
    function testBuyTokenSuccessfully() public {
        vm.prank(buyer);
        nftContract.buyToken{value: price}(tkIPFS1);

        assertEq(nftContract.ownerOf(0), buyer);
        assertEq(nftContract.tokenURI(0), tkIPFS1);
    }


    /// @notice Several NFT buying test
    function testMultipleTokenPurchases() public {
        vm.prank(buyer);
        nftContract.buyToken{value: price}(tkIPFS1);
        vm.prank(buyer);
        nftContract.buyToken{value: price}(tkIPFS2);

        assertEq(nftContract.tokenCounter(), 2);
    }

    /// @notice Correct URI test
    function testTokenURIIsSetCorrectly() public {
        vm.prank(buyer);
        nftContract.buyToken{value: price}(tkIPFS1);

        string memory tokenURI = nftContract.tokenURI(0);
        assertEq(tokenURI, tkIPFS1);
    }
}