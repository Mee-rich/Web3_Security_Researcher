// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/vulnerable/access-control/Vault.sol";
import "../src/attacker/access-control/AccessControlAttack.sol";

contract AccessControlPoCTest is Test {
    Vault vault;
    VaultAttack attackerContract;

    address deployer = address(0xA);
    address attackerEOA = address(0xB);

    function setUp() public {
        vm.deal(deployer, 100 ether);
        vm.deal(attackerEOA, 1 ether);

        // Deploy Vault with funds
        vm.startPrank(deployer);
        vault = new Vault{value: 50 ether}();
        vm.stopPrank();

        // Deploy attacker contract
        vm.startPrank(attackerEOA);
        attackerContract = new VaultAttack(address(vault));
        vm.stopPrank();
    }

    function test_AccessControlExploit() public {
        uint256 vaultBalanceBefore = address(vault).balance;
        uint256 attackerBalanceBefore = address(attackerContract).balance;

        vm.prank(attackerEOA);
        attackerContract.exploit();

        uint256 vaultBalanceAfter = address(vault).balance;
        uint256 attackerBalanceAfter = address(attackerContract).balance;

        console.log("Vault balance before:", vaultBalanceBefore);
        console.log("Vault balance after:", vaultBalanceAfter);
        console.log("Attacker balance after:", attackerBalanceAfter);

        assertEq(vaultBalanceAfter, 0);
        assertGt(attackerBalanceAfter, attackerBalanceBefore);
    }
}
