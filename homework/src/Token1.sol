// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Permit.sol";

contract Token1 is ERC20Permit {
    uint256 public pricePerToken = 0.01 ether;
    address public feeRecipient;
    uint256 public tokenAmount = 5000000 * 10 ** decimals();
    uint256 public transferFee = 1;

    constructor() ERC20("FREAKTOKEN", "FRK") ERC20Permit("FREAKTOKEN") {
        feeRecipient = msg.sender;
        _mint(feeRecipient, tokenAmount);
    }

    /// @notice Buy tokens
    function buyToken() external payable {
        uint256 amountToBuy = (msg.value * 10 ** decimals()) / pricePerToken;
        require(amountToBuy > 0, "Not enough ether");
        require(balanceOf(feeRecipient) >= amountToBuy, "Not enough tokens");
        _transfer(feeRecipient, msg.sender, amountToBuy);
    }

    /// @notice Transfer with Fee
    function transfer(address recipient, uint256 amount) public override returns (bool) {
        uint256 leftAmount = 100;
        uint256 fee = (amount * transferFee) / leftAmount;
        if (msg.sender == feeRecipient) {
            fee = 0;
        }
        uint256 amountAfterFee = amount - fee;

        super.transfer(feeRecipient, fee);
        super.transfer(recipient, amountAfterFee);

        return true;
    }

    /// @notice Overriding including fee
    function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
        uint256 leftAmount = 100;
        uint256 fee = (amount * transferFee) / leftAmount;
        if (msg.sender == feeRecipient) {
            fee = 0;
        }
        uint256 amountAfterFee = amount - fee;
        uint256 currentAllowance = allowance(sender, msg.sender);
        require(currentAllowance >= amount, "Transfer amount exceeds allowance");
        _approve(sender, msg.sender, currentAllowance - amount);
        _transfer(sender, feeRecipient, fee);
        _transfer(sender, recipient, amountAfterFee);

        return true;
    }
}
