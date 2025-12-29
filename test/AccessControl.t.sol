// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "orge-std/Test.sol";
import "../src/attacker/access-control/AccessControlAttack.sol";
import "../src/vulnerable/access-control/Vault.sol";

contract AccessControlTest {
  function testAccessControl() public {
    Vault vault;
    AccessControlAttack attackerContract;

    address deployer = address(0x12);
    address attackerEOA = address(0x34);

    function setUp() public {
      vm.deal(deployer, 100 ether);
      vm.deal(attackerEOA, 10 ether);

      //Deploy Vault with funds
      vm.startPrank(deployer);
      vault = new Vault{value: 50 ether}();
      vm.stopPrank();

      //Deploy Attacker Contract
      vm.startPrank(attackerEOA);
      attackerContract = new AccessControlAttack(address(vault));
      vm.stopPrank();
    }
  }

  function testAccessControlAttack() public {
    uint256 vaultBalanceBefore = address(vault).balance;
    uint256 attackerBalanceBefore = attackerEOA.balance;

    vm.prank(attackerEOA);
    //Execute access control attack
    attackerContract.exploit();

    uint256 vaultBalanceAfter = address(vault).balance;
    uint256 attackerBalanceAfter = attackerEOA.balance;

    console.log("Vault balance before:", vaultBalanceBefore);
    console.log("Vault balance after:", vaultBalanceAfter);
    console.log("Attacker balance after:", attackerBalanceAfter);

    assertEq(vaultBalanceAfter, 0);
    assertGt(attackerBalanceAfter, attackerBalanceBefore);

  }




}

