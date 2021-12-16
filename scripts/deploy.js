const {ethers} = require("hardhat");
const colors = require("colors/safe");

async function main() {
	
	const [deployer] = await ethers.getSigners();
	
	// Grab the Contract factory
	const contractName = "TestContract"
	const contractFactory = await ethers.getContractFactory(contractName)
	console.log(contractFactory);
	
	console.log("Account balance:", (await deployer.getBalance()).toString()); // Wei
	
	// Start deployment, returning a promise that resolves a contract object
	const contract = await contractFactory.deploy("TestContract", "T2", "0xD3c30CAD88f5572C861e2e8244Bec49223cf625a", "ipfs://test/", "https://not.revealed.test/"); // instance of the contract

	console.log("Contract deployed to the address: ")
	console.log(colors.green(contract.address))

	console.log(contract.address);
	console.log(contract.deployTransaction.hash);
	await contract.deployed()
	
}

main()
	.then(() => process.exit(0))
	.catch(error => {
		console.error(error);
		process.exit(0);
	})
