// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/console.sol";

// “The contract uses tx.origin for authorization,
// allowing an attacker to bypass access control by forwarding
// calls through a malicious contract.”

contract BadModifierVault {
    address public owner;

    constructor() payable {
        owner = tx.origin; // The vlnerability stems from using tx.origin here
        // owner = msg.sender; // The fix would be to use msg.sender instead
    }

    // ❌ BAD MODIFIER
    modifier onlyOwner() {
        // console.log("tx.origin:", tx.origin);
        // console.log("msg.sender:", msg.sender);
        // console.log("owner:", owner);
        require(tx.origin == owner, "Not Owner");
        _;
    }

    function withdrawAll() external onlyOwner {
        payable(msg.sender).transfer(address(this).balance);
    }

    function getBalance() external view returns (uint256) {
        return address(this).balance;
    }
}
