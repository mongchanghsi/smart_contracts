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
  const contract = await ethers.getContractFactory(ExistingContracts.NFT721);

  const deployedContract = await contract.deploy(
    "MockERC721", "MockERC", "MockBaseUri"
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

// Fakemarketplace contract addr 0xcb55E4aD7Fab4c6DDf91d9b381347941C8Cdb0C9
// DAO contract addr 0x0C4d3ABD43e714871dc65043057B146cdB8bc3F6
