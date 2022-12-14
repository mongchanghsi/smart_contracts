// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract NFT_ERC721 is ERC721Enumerable, Ownable {
  string private _baseTokenURI;
  uint256 public _presalePrice = 0.008 ether;
  uint256 public _publicSalePrice = 0.01 ether;

  bool public _paused;
  uint256 public maxSupply = 20;
  uint256 public currentSupply;

  bool public presaleStarted;
  uint256 public presaleEnded;

  uint8 public maxWhitelistAddresses = 10;
  uint8 public currentNumberOfWhitelistedAddresses;

  uint8 public maxMintPerWallet = 1;

  mapping(address => bool) public whitelistedAddresses;
  mapping(address => uint256) public userToNumberOfMintedNFT;

  modifier onlyWhenNotPaused {
      require(!_paused, "[NFT_ERC721 Error] Contract currently paused");
      _;
  }

  constructor (string memory _name, string memory _symbol, string memory baseURI) ERC721(_name, _symbol) {
    _baseTokenURI = baseURI;
  }

  function whitelistAddress (address _address) public onlyOwner {
    require(!whitelistedAddresses[msg.sender], '[NFT_ERC721 Error] This address is already been whitelisted.');
    require(currentNumberOfWhitelistedAddresses + 1 <= maxWhitelistAddresses, '[Whitelist Error] Whitelist is full.');

    currentNumberOfWhitelistedAddresses++;
    whitelistedAddresses[_address] = true;
  }

  function startPresale() public onlyOwner {
    presaleStarted = true;
    presaleEnded = block.timestamp + 5 minutes;
  } 

  function presaleMint() public payable onlyWhenNotPaused {
    require(presaleStarted && block.timestamp < presaleEnded, "[NFT_ERC721 Error] Presale is not running.");
    require(whitelistedAddresses[msg.sender], "[NFT_ERC721 Error] This address is not whitelisted.");
    require(currentSupply < maxSupply, "[NFT_ERC721 Error] Minted out.");
    require(msg.value >= _presalePrice, "[NFT_ERC721 Error] Insufficient ether.");
    require(userToNumberOfMintedNFT[msg.sender] < maxMintPerWallet, "[NFT_ERC721 Error] User already minted maximum amount allowed.");

    userToNumberOfMintedNFT[msg.sender]++;
    currentSupply++;
    _safeMint(msg.sender, currentSupply);
  }

  function mint() public payable onlyWhenNotPaused {
    require(presaleStarted && block.timestamp >=  presaleEnded, "[NFT_ERC721 Error] Presale has not ended yet");
    require(currentSupply < maxSupply, "[NFT_ERC721 Error] Minted out.");
    require(msg.value >= _publicSalePrice, "[NFT_ERC721 Error] Insufficient ether.");
    require(userToNumberOfMintedNFT[msg.sender] < maxMintPerWallet, "[NFT_ERC721 Error] User already minted maximum amount allowed.");

    userToNumberOfMintedNFT[msg.sender]++;
    currentSupply++;
    _safeMint(msg.sender, currentSupply);
  }

  function _baseURI() internal view virtual override returns (string memory) {
    return _baseTokenURI;
  }

  function setBaseURI(string memory _newBaseURI) external onlyOwner {
    _baseTokenURI = _newBaseURI;
  }

  function setPaused(bool val) public onlyOwner {
    _paused = val;
  }

  function withdraw() public onlyOwner  {
    address _owner = owner();
    (bool success, ) =  _owner.call{value: address(this).balance}("");
    require(success, "[NFT_ERC721 Error] Failed to send Ether");
  }

  receive() external payable {}

  fallback() external payable {}
}