/// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Vault{
  adress public owner;

  constructor() payable {
    owner = msg.sender;

    //Vulnerability: Anyone can become owner
    function setOwner(address newOwner) public {
      owner = newOwner;
    }

    function withdrawAll() external {
      require(msg.sender == owner, "Not the owner");
      payable(owner).transfer(address(this).balance);
    }

    function getBalance() external view returns (uint256) {
      return address(this).balance;
    }
}
