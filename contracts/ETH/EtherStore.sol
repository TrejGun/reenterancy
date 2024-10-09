// SPDX-License-Identifier: UNLICENSED

// Author: TrejGun
// Email: trejgun@gmail.com
// Website: https://ethberry.io/

pragma solidity ^0.8.20;

contract EtherStore {
  mapping(address => uint256) public balances;

  function deposit() public payable {
    balances[msg.sender] += msg.value;
  }

  function withdraw() public {
    uint256 balance = balances[msg.sender];
    require(balance > 0, "Insufficient balance");

    (bool sent, ) = msg.sender.call{value: balance}("");
    require(sent, "Failed to send Ether");

    balances[msg.sender] = 0;
  }
}
