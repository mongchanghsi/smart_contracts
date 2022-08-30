# Smart Contracts (Solidity)

This repository serves as my practice to develop smart contracts in solidity. Each of these contracts are independent unless I grouped them in sub-folders. Some of the contracts are either followed closey to existing tutorials or inspired by some of them, in which it is credited below.

`Todo.sol` is inspired from a tutorial series by [LearnWeb3](https://learnweb3.io/courses/c1d7081b-63a9-4c6e-b35c-9fcbbad418b2/lessons/18dad5bd-3a51-4d2e-944e-db37edd74855). This contract can be view on [Rinkeby Etherscan](https://rinkeby.etherscan.io/address/0xB1351115BA3b99DE2bcD9b11E9860c6471B615AD).

`Whitelist.sol` is inspired from a tutorial series by [LearnWeb3](https://learnweb3.io/courses/c1d7081b-63a9-4c6e-b35c-9fcbbad418b2/lessons/acd04999-1230-4533-b6de-6b4e4978914c). This contract can be view on [Rinkeby Etherscan](https://rinkeby.etherscan.io/address/0xA0fbE75BE077270Ba93BE8AD6567c0fdCDb4340C).

## How to deploy a contract

1. Dive into `scripts/deploy.js` and change according to which contract and the args of the contract that you want to deploy.
2. Run `npm run deploy:rinkeby`
3. Once it is deployed, you can verify the contract either via etherscan or running `npm run verify:rinkeby <CONTRACT ADDRESS> <Contructor args>`
