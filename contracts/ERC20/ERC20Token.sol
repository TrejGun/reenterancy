// SPDX-License-Identifier: UNLICENSED

// Author: TrejGun
// Email: trejgun@gmail.com
// Website: https://ethberry.io/

pragma solidity ^0.8.20;

import {ERC1363} from "@openzeppelin/contracts/token/ERC20/extensions/ERC1363.sol";
import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract ERC20Token is ERC1363, Ownable {
  constructor(string memory name, string memory symbol) ERC20(name, symbol) Ownable(_msgSender()) {

  }

  function mint(address to, uint256 amount) public virtual onlyOwner {
    _mint(to, amount);
  }
}
