// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./interfaces/INFT_ERC721.sol";

/* 
    This contracts allows users who owns NFT_ERC721 tokens to create proposals and vote on them.
    Hence, it is dependent on NFT_ERC721 Contract
*/

struct Proposal {
    string title;
    string description;
    uint256 deadline;
    uint256 yayVotes;
    uint256 nayVotes;
    bool executed;
    mapping(uint256 => bool) voters;
}

enum Vote {
    YAY, // 0
    NAY // 1
}

contract DAO is Ownable {
    mapping(uint256 => Proposal) public proposals;
    uint256 public numberOfProposals;

    INFT_ERC721 NFT_ERC721;

    constructor(address _nftErc721ContractAddr) payable {
        NFT_ERC721 = INFT_ERC721(_nftErc721ContractAddr);
    }

    modifier nftHolderOnly() {
        require(NFT_ERC721.balanceOf(msg.sender) > 0, "[DAO Error] This address does not hold a NFT_ERC721 NFT.");
        _;
    }

    modifier activeProposalOnly(uint256 proposalIndex) {
        require(proposals[proposalIndex].deadline > block.timestamp, "[DAO Error] This proposal has past the deadline.");
        _;
    }

    modifier inactiveProposalOnly(uint256 proposalIndex) {
        require(proposals[proposalIndex].deadline <= block.timestamp, "DEADLINE_NOT_EXCEEDED");
        require(proposals[proposalIndex].executed == false, "PROPOSAL_ALREADY_EXECUTED");
        _;
    }

    function createProposal(string memory _title, string memory _description) external nftHolderOnly {
        Proposal storage proposal = proposals[numberOfProposals];
        proposal.title = _title;
        proposal.description = _description;
        proposal.deadline = block.timestamp + 5 minutes;
    
        numberOfProposals++;
    }

    function voteOnProposal(uint256 proposalIndex, Vote vote) external nftHolderOnly activeProposalOnly(proposalIndex) {
        Proposal storage proposal = proposals[proposalIndex];

        uint256 voterNFTBalance = NFT_ERC721.balanceOf(msg.sender);
        uint256 numVotes = 0;

        for (uint256 i = 0; i < voterNFTBalance; i++) {
            uint256 tokenId = NFT_ERC721.tokenOfOwnerByIndex(msg.sender, i);
            if (proposal.voters[tokenId] == false) {
                numVotes++;
                proposal.voters[tokenId] = true;
            }
        }
        require(numVotes > 0, "[DAO Error] User has already utilised all of his NFT to vote this proposal.");

        if (vote == Vote.YAY) {
            proposal.yayVotes += numVotes;
        } else {
            proposal.nayVotes += numVotes;
        }
    }

    function executeProposal(uint256 proposalIndex) external nftHolderOnly inactiveProposalOnly(proposalIndex) {
        Proposal storage proposal = proposals[proposalIndex];

        if (proposal.yayVotes > proposal.nayVotes) {
            // Code to execute the purpose of this proposal
        }
        proposal.executed = true;
    }

    function withdrawEther() external onlyOwner {
        payable(owner()).transfer(address(this).balance);
    }

    receive() external payable {}

    fallback() external payable {}
}