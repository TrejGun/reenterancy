// SPDX-License-Identifier: UNLICENSED

// Author: TrejGun
// Email: trejgun@gmail.com
// Website: https://ethberry.io/

pragma solidity ^0.8.20;

import {IERC1363Receiver} from "@openzeppelin/contracts/interfaces/IERC1363Receiver.sol";
import {IERC1363Spender} from "@openzeppelin/contracts/interfaces/IERC1363Spender.sol";

import "./ERC20Token.sol";

contract ERC20Store is IERC1363Receiver, IERC1363Spender {
  ERC20Token public token;

  mapping(address => uint256) public balances;

  constructor(address tokenAddress) {
    token = ERC20Token(tokenAddress);
  }

  function deposit(uint256 amount) public {
    token.transferFromAndCall(msg.sender, address(this), amount);
    balances[msg.sender] += amount;
  }

  function withdraw() public {
    uint256 balance = balances[msg.sender];
    require(balance > 0, "Insufficient balance");

    bool sent = token.transferAndCall(msg.sender, balance);
    require(sent, "Failed to send ERC20");

    balances[msg.sender] = 0;
  }

  function onTransferReceived(
    address,
    address,
    uint256,
    bytes memory
  ) external pure override returns (bytes4) {
    return this.onTransferReceived.selector;
  }

  function onApprovalReceived(address, uint256, bytes memory) external pure override returns (bytes4) {
    return this.onApprovalReceived.selector;
  }
}
