require("@nomicfoundation/hardhat-toolbox");

require("dotenv").config();
module.exports = {
  solidity: "0.8.17",
  paths: {
    artifacts: "../myapp/src/artifacts",
  },
  settings: {
    optimizer: {
      enable: true,
      runs: 200,
    },
  },
  networks: {
    hardhat: {
      chainId: 31337,
    },
    sepolia: {
      url: process.env.SEPOLIA_URL,
      accounts: [process.env.PRIVATE_KEY],
    },
    mumbai: {
      url: process.env.MUMBIA_URL,
      accounts: [process.env.PRIVATE_KEY],
    },
  },
  gasReporter: {
    enabled: true,
    currency: "USD",
    noColors: true,
    token: "ETH",
    gasPriceApi: "api.etherscan.io/api?module=proxy&action=eth_gasPrice",
    outputFile: "gas-report.txt",
    coinmarketcap: process.env.COINMARKETCAP,
  },
  mocha: {
    timeout: 50000,
  },
  etherscan: {
    apiKey: process.env.POLYGON_API_KEY,
  },
};
