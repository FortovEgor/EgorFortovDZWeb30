// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.12;

import "forge-std/Test.sol";
import "../src/TokenOne.sol";

contract TokenOneTest is Test {
    TokenOne public tk;
    address public dep;
    address public u1;
    address public u2;
    uint256 public bal;

    function setUp() public {
        dep = address(this);
        u1 = address(0x1);
        u2 = address(0x2);

        tk = new TokenOne();
        bal = tk.balanceOf(dep);
    }

    function testBuyToken() public {
        vm.deal(u1, 1 ether);
        vm.prank(u1);
        tk.buyToken{value: 0.01 ether}();

        uint256 expAmt = (0.01 ether * 10 ** tk.decimals()) / tk.pricePerToken();
        assertEq(tk.balanceOf(u1), expAmt, "Wrong token amount");

        uint256 expBal = bal - expAmt;
        assertEq(tk.balanceOf(dep), expBal, "Wrong deployer balance");
    }

    function testFeeTransfer() public {
        uint256 amt = 5000 * 10 ** tk.decimals();
        uint256 leftAmount = 100;
        tk.transfer(u1, amt);
        vm.prank(u1);
        tk.transfer(u2, amt);

        uint256 fee = (amt * tk.transferFee()) / leftAmount;
        uint256 amtAfterFee = amt - fee;

        assertEq(tk.balanceOf(u2), amtAfterFee, "Wrong token amount");
        assertEq(tk.balanceOf(dep), bal - amt + fee, "Wrong fee received");
        assertEq(tk.balanceOf(u1), 0, "Wrong balance");
    }

    function testTransferAndFee() public {
        uint256 amt = 5000 * 10 ** tk.decimals();
        uint256 leftAmount = 100;
        tk.transfer(u1, amt);

        vm.prank(u1);
        tk.approve(u2, amt);

        vm.prank(u2);
        tk.transferFrom(u1, u2, amt);

        uint256 fee = (amt * tk.transferFee()) / leftAmount;
        uint256 amtAfterFee = amt - fee;

        assertEq(tk.balanceOf(u2), amtAfterFee, "Wrong token amount");
        assertEq(tk.balanceOf(dep), bal - amt + fee, "Wrong fee received");
        assertEq(tk.balanceOf(u1), 0, "Wrong balance");

        uint256 remAllow = tk.allowance(u1, u2);
        assertEq(remAllow, 0, "Allowance not zero");
    }
}