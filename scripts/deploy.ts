// import { ethers } from "hardhat";
import "@nomiclabs/hardhat-ethers";

enum ExistingContracts {
  Todo = "Todo",
  Whitelist = "Whitelist",
  NFT721 = "NFT_ERC721",
}

async function main() {
  const contract = await ethers.getContractFactory(ExistingContracts.NFT721);

  const deployedContract = await contract.deploy("NFT", "NT", "mockBaseUri");

  await deployedContract.deployed();

  console.log("Deployed Contract Address:", deployedContract.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
