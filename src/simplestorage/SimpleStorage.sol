// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract SimpleStorage {
    uint256 myFavoriteNumber;

   struct Person {
    uint256 myFavoriteNumber;
    string name;
   }

    // Public array
   Person[] public listOfPeople;
}