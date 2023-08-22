# MyEpicGame Contract

MyEpicGame is a Solidity smart contract that implements an NFT game where players can mint character NFTs, battle a big boss, and interact with the game's mechanics.

## Table of Contents

- [Introduction](#introduction)
- [Getting Started](#getting-started)
- [Game Mechanics](#game-mechanics)
- [Smart Contract Details](#smart-contract-details)
- [License](#license)

## Introduction

MyEpicGame is an Ethereum-based game built using Solidity smart contracts. In this game, players can mint unique character NFTs, each with its own attributes like health points (HP), attack damage, and more. These characters can then be used to battle a powerful boss character.

The game is implemented as an ERC-721 token contract, allowing each character to be represented as a unique NFT.

## Getting Started

To interact with the MyEpicGame contract, you'll need an Ethereum wallet and a development environment like [Hardhat](https://hardhat.org/). Follow these steps to get started:

1. Clone this repository: `git clone https://github.com/ankit2020bhagat/NFT_Browser_Game.git`
2. Install dependencies: `npm install`
3. Configure your Ethereum wallet and network settings in the Hardhat configuration file (`hardhat.config.js`).
4. Deploy the smart contract to your chosen network: `npx hardhat run scripts/deploy.js --network <network-name>`
5. Interact with the contract using the provided functions.

## Game Mechanics

- Players can mint character NFTs by calling the `mintCharacterNFT` function, which generates a new NFT with specific attributes.
- Players can use their characters to attack the boss character using the `attackboss` function. The boss will retaliate with its own attack.
- The battle continues until either the player's character or the boss character's HP reaches zero.
- Character attributes are stored on-chain and can be queried using various functions.
- The smart contract also provides a function to generate the token URI for each NFT, including character attributes.

## Smart Contract Details

The MyEpicGame contract is built on top of the ERC-721 standard. It contains functions to mint NFTs, perform attacks, retrieve character attributes, and more.

**Key Components:**

- `mintCharacterNFT(uint256 _characterIndex)`: Mint a character NFT for the sender.
- `attackboss()`: Perform an attack on the boss character.
- `checkIfUserHasNFT()`: Check if the user owns a character NFT.
- `getAllDefaultcharacter()`: Retrieve attributes of all default characters.

Please refer to the source code for more details on functions and their usage.

## License

This project is licensed under the [MIT License](LICENSE).
