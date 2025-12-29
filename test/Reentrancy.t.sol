// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/vulnerable/reentrancy/VulnerableBank.sol";
import "../src/attacker/reentrancy/ReentrancyAttack.sol";

contract ReentrancyPoCTest is Test{
  VulnerableBank bank;
  ReentrancyAttack attacker;

  address deployer = address(0x1);
  address attackerEOA = address(0x2);

  function setUp() public {
    vm.deal(deployer, 100 ether);
    vm.deal(attackerEOA, 10 ether);

    vm.startPrank(deployer);
    bank = new VulnerableBank();
    vm.stopPrank();

    vm.startPrank(attackerEOA);
    attacker = new ReentrancyAttack(address(bank));
    vm.stopPrank();

    // Seed the bank with funds from deployer
    vm.prank(deployer);
    bank.deposit{value: 20 ether}();
  }
  function testReentrancyAttack() public {
     // Record initial balances
    uint256 bankBalanceBefore = address(bank).balance;
    uint256 attackerBalanceBefore = attackerEOA.balance;

    vm.prank(attackerEOA);
    // Execute the reentrancy attack
    attacker.attack{value: 1 ether}();

    uint256 bankBalanceAfter = address(bank).balance;
    uint256 attackerBalanceAfter = address(attacker).balance;

    console.log("Bank balance before:", bankBalanceBefore);
    console.log("Bank balance after:", bankBalanceAfter);
    console.log("Attacker balance before:", attackerBalanceBefore);
    console.log("Attacker balance after:", attackerBalanceAfter);

    assertEq(bankBalanceAfter, 0);
    assertGt(attackerBalanceAfter, attackerBalanceBefore);
  }
}
