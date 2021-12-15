// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract TestContract is ERC721, ERC721Enumerable, Ownable {
	using Strings for uint256;
	string public baseUri;
	string public baseExtension = ".json";
	string public notRevealedUri;
	bool public paused = true;
	bool public pausedWhitelist = true;
	bool public revealed = false;
	uint256 public constant MAX_SUPPLY = 19999;
	uint256 public constant MAX_PER_TRANSACTION = 30;
	uint256 public PRICE_FIRST = 0.08 ether;
	uint256 public PRICE_PUBLIC = 0.09 ether;
	
	function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal override(ERC721, ERC721Enumerable) {
		super._beforeTokenTransfer(from, to, tokenId);
	}
	
	function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721, ERC721Enumerable) returns (bool) {
		return super.supportsInterface(interfaceId);
	}
	
	function setBaseURI(string memory newBaseURI) public onlyOwner() {
		baseUri = newBaseURI;
	}
	
	function setBaseExtension(string memory _newBaseExtension) public onlyOwner {
		baseExtension = _newBaseExtension;
	}
	
	function _baseURI() internal view virtual override returns (string memory) {
		return baseUri;
	}
	
	function tokenURI(uint256 tokenId) public view override(ERC721) returns (string memory){
		require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
		if (revealed == false) {
			return notRevealedUri;
		}
		string memory currentBaseURI = _baseURI();
		return bytes(currentBaseURI).length > 0
		? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension))
		: "";
	}
	
	function setPaused(bool newState) public onlyOwner {
		paused = newState;
	}
	
	function setPausedWhitelist(bool newState) public onlyOwner {
		pausedWhitelist = newState;
	}
	
	function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
		notRevealedUri = _notRevealedURI;
	}
	
	constructor(string memory _name,
		string memory _symbol,
		string memory _initBaseURI,
		string memory _initNotRevealedUri) ERC721(_name, _symbol) {
		setBaseURI(_initBaseURI);
		setNotRevealedURI(_initNotRevealedUri);
	}
	
	function mint(uint numberOfTokens) public payable {
		uint256 totalSupply = totalSupply();
		require(!paused, "Contract Paused");
		require(numberOfTokens <= MAX_PER_TRANSACTION, "Exceeded max token purchase");
		require(totalSupply + numberOfTokens <= MAX_SUPPLY, "Purchase would exceed max tokens");
		if ((balanceOf(msg.sender) == 0)) {
			require(isValidPrice(numberOfTokens, PRICE_FIRST), "Ether values is not correct");
		} else {
			require(isValidPrice(numberOfTokens, PRICE_PUBLIC), "Ether values is not correct");
		}
		for (uint256 i = 0; i < numberOfTokens; i++) {
			_safeMint(msg.sender, totalSupply + i);
		}
	}
	
	function whitelistMint(uint256 numberOfTokens) public payable {
		uint256 totalSupply = totalSupply();
		require(!pausedWhitelist, "Whitelist Paused");
		require(numberOfTokens <= MAX_PER_TRANSACTION, "Exceeded max token purchase");
		require(totalSupply + numberOfTokens <= MAX_SUPPLY, "Purchase would exceed max tokens");
		require(isValidPrice(numberOfTokens, PRICE_FIRST), "Ether values is not correct");
		for (uint256 i = 0; i < numberOfTokens; i++) {
			_safeMint(msg.sender, totalSupply + i);
		}
	}
	
	function reserve(uint256 numberOfTokens) public onlyOwner {
		uint totalSupply = totalSupply();
		require(totalSupply + numberOfTokens <= MAX_SUPPLY, "Purchase would exceed max tokens");
		for (uint256 i = 0; i < numberOfTokens; i++) {
			_safeMint(msg.sender, totalSupply + i);
		}
	}
	
	function isValidPrice(uint256 _amount, uint256 _price) internal returns (bool){
		uint256 totalValue = _price + (0.06 ether * (_amount - 1));
		return msg.value >= totalValue;
	}
	
	function withdraw() public onlyOwner {
		uint balance = address(this).balance;
		payable(msg.sender).transfer(balance);
	}
}
