pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";

contract Merkle {
	
	bytes32 public merkleRoot = 0x9f3a4509aa49dde177706de9a4168bf3975ccf5958a4a48677331db3cd0afca9;
	
	mapping(address => bool) public whitelistClaimed;
	
	function whitelistMint(bytes32[] calldata _merkleProof) public {
		
		require(!whitelistClaimed[msg.sender], "Address has already claimed");
		
		bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
		require(MerkleProof.verify(_merkleProof, merkleRoot, leaf), "Invalid Proof");
		
		whitelistClaimed[msg.sender] = true;
		
		
	}
}
