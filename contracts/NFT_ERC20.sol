// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./interfaces/INFT_ERC721.sol";

/* 
    This contracts allows users who owns NFT_ERC721 tokens to claim NFT_ERC20 tokens or to purchase NFT_ERC20
    Hence, it is dependent on NFT_ERC721 Contract
*/

contract NFT_ERC20 is ERC20, Ownable {
    uint256 public constant tokenPrice = 0.001 ether;
    uint256 public constant tokensPerNFT = 10 * 10**18;
    uint256 public constant maxTotalSupply = 10000 * 10**18;

    INFT_ERC721 NFT_ERC721;
    mapping(uint256 => bool) public tokenIdsClaimed;

    constructor(string memory _name, string memory _symbol, address _nftErc721ContractAddr) ERC20(_name, _symbol) {
        NFT_ERC721 = INFT_ERC721(_nftErc721ContractAddr);
    }

    function mint(uint256 amount) public payable {
        uint256 _requiredAmount = tokenPrice * amount;
        require(msg.value >= _requiredAmount, "[NFT_ERC20 Error] Insufficient ether.");

        uint256 amountWithDecimals = amount * 10**18;
        require(
            (totalSupply() + amountWithDecimals) <= maxTotalSupply,
            "[NFT_ERC20 Error] Exceeds the max total supply available."
        );

        _mint(msg.sender, amountWithDecimals);
    }

    function claim() public {
        address sender = msg.sender;
        uint256 balance = NFT_ERC721.balanceOf(sender);
        require(balance > 0, "[NFT_ERC20 Error] You dont own any NFT_ERC721 NFT's");
        uint256 amount = 0;
        for (uint256 i = 0; i < balance; i++) {
            uint256 tokenId = NFT_ERC721.tokenOfOwnerByIndex(sender, i);
            if (!tokenIdsClaimed[tokenId]) {
                amount += 1;
                tokenIdsClaimed[tokenId] = true;
            }
        }
        require(amount > 0, "[NFT_ERC20 Error] You have already claimed all the tokens");
        _mint(msg.sender, amount * tokensPerNFT);
    }

    function withdraw() public onlyOwner {
    address _owner = owner();
    (bool sent, ) = _owner.call{value: address(this).balance}("");
    require(sent, "[NFT_ERC20 Error] Failed to send Ether");
    }

    receive() external payable {}

    fallback() external payable {}
}