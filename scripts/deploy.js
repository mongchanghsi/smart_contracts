const { ethers } = require("hardhat");

async function main() {
  // const todoContract = await ethers.getContractFactory("Todo");
  const whitelistContract = await ethers.getContractFactory("Whitelist");

  // const deployedTodoContract = await todoContract.deploy();
  const deployedWhitelistContract = await whitelistContract.deploy(10);

  await deployedWhitelistContract.deployed();

  console.log("Deployed Contract Address:", deployedWhitelistContract.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
