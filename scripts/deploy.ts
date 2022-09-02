// import { ethers } from "hardhat";
import "@nomiclabs/hardhat-ethers";

enum ExistingContracts {
  Todo = "Todo",
  Whitelist = "Whitelist",
  NFT721 = "NFT_ERC721",
  ERC20 = "NFT_ERC20",
  DAO = "DAO",
}

async function main() {
  const contract = await ethers.getContractFactory(ExistingContracts.DAO);

  const deployedContract = await contract.deploy(
    "0xf731375b6a48a7dB5214268c00a8fef89a5502Cf"
  );

  await deployedContract.deployed();

  console.log("Deployed Contract Address:", deployedContract.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
