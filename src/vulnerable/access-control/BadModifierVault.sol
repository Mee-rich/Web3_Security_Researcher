// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract BadModifierVault {
    address public owner;

    constructor() payable {
      owner = msg.sender;
    }
    // Bad Modifier: condition is wrongly implemented
    // Uses tx.origin instead of msg.sender
    // Critical security flaw
    modifier onlyOwner() {
      require(tx.origin == owner, "Not Owner");
      _;
    }
    function withdrawAll() external onlyOwner {
      payable(owner).transfer(address(this).balance);
    }
    function chnangeOwner(address newOwner) external onlyOwner {
      owner = newOwner;
    }
    function getBalance() external view returns (uint256) {
      return address(this).balance;
    }
}

