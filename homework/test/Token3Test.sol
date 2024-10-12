// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.12;

import "forge-std/Test.sol";
import "../src/TokenThree.sol";

contract TokenThreeTest is Test {
    TokenThree internal token;
    string internal URIsamle = "https://example.com/token/{id}.json";
    address internal buyer;
    
    function setUp() public {
        token = new TokenThree();
        buyer = address(0xBEEF);
    }

    /// @notice Test token transaction
    function testBuyTokenSuccess() public {
        uint256 amnt = 5;
        uint256 price = 0.01 ether * amnt;

        vm.deal(buyer, price);

        vm.prank(buyer);
        token.buyToken{value: price}(amnt, URIsamle);

        uint256 balance = token.balanceOf(buyer, 0);
        assertEq(balance, amnt, "Bad balance");

        string memory uri = token.uri(0);
        assertEq(uri, URIsamle, "Bad URI");

        uint256 contractBalance = address(token).balance;
        assertEq(contractBalance, price, "Bad Ether balance");
    }

    /// @notice Not enough NFT
    function testBuyTokenInsufficientETH() public {
        uint256 notEnoughPrice = 0.01 ether * 100 - 2 wei;

        vm.deal(buyer, notEnoughPrice);

        vm.prank(buyer);
        vm.expectRevert(bytes("Not enought coins to buy"));
        token.buyToken{value: notEnoughPrice}(100, URIsamle);
    }
}