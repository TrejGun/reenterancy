import { task } from "hardhat/config";

task("accounts", "Prints the list of accounts", async (_, hre) => {
  const accounts = await hre.ethers.getSigners();

  for (const account of accounts) {
    console.info(account.address);
  }
});

// hardhat accounts --network ethberry_besu
