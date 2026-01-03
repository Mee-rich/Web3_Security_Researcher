// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// A storage layout vulnerability where an owner variable is shadowed
// in a derived contract, allowing unauthorized access to owner-only functions.

contract Base {
  address public owner;

  constructor() payable {
    owner = msg.sender;
  }
  modifier onlyOwner() {
    require(mesg.sender == owner, "Not Owner");
    _;
  }

}
