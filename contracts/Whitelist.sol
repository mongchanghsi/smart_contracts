// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;

contract Whitelist {
  uint8 public maxWhitelistAddresses;
  uint8 public currentNumberOfWhitelistedAddresses;

  mapping(address => bool) public whitelistedAddresses;

  constructor (uint8 _maxWhitelistAddresses) {
    maxWhitelistAddresses = _maxWhitelistAddresses;
  }

  function whitelistAddress () public {
    require(!whitelistedAddresses[msg.sender], '[Whitelist Error] This address is already been whitelisted.');
    require(currentNumberOfWhitelistedAddresses + 1 <= maxWhitelistAddresses, '[Whitelist Error] Whitelist is full.');

    currentNumberOfWhitelistedAddresses++;
    whitelistedAddresses[msg.sender] = true;
  }
}