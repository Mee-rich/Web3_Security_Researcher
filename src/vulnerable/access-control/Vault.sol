// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Vault {
    address public owner;

    constructor() payable {
        owner = msg.sender;
    }

    // ❌ VULNERABILITY: Anyone can become owner
    function setOwner(address newOwner) external {
        owner = newOwner;
    }


    function withdrawAll() external {
        require(msg.sender == owner, "Not owner");
        payable(owner).transfer(address(this).balance);
    }

    function getBalance() external view returns (uint256) {
        return address(this).balance;
    }
}
