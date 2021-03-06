/**
 * @type import('hardhat/config').HardhatUserConfig
 */
require('dotenv').config();
require('@nomiclabs/hardhat-ethers');
const {METAMASK_PRIVATE_KEY, RINKEBY_API_URL} = process.env
module.exports = {
  solidity: {
    version: "0.8.0",
    settings: {
      optimizer: {
        enabled: true,
        runs: 200
      }
    }
  },
  defaultNetwork: "rinkeby",
  networks: {
    hardhat: {},
    rinkeby: {
      url: RINKEBY_API_URL,
      accounts: [`0x${METAMASK_PRIVATE_KEY}`],
      gas: "auto",
      gasPrice: "auto"
    },
  }
};
