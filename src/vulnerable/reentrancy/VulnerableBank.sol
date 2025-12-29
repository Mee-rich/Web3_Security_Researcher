// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract VulnerableBank{
  mapping(address => uint256) public balances;

  function deposit() external payable{
    balances[msg.sender] += msg.value;
  }

  function withdraw() external {
    uint256 bal = balances[msg.sender];
    require (bal > 0, "Insufficient balance");

    // Vulnerable: external call before state update
    (bool sent,) = msg.sender.call{value: bal}("");
    require(sent, "sent failed");

    balances[msg.sender] = 0;
  }

  function getBalance() external view returns (uint256) {
    return address(this).balance;
  }
}
