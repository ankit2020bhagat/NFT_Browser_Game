# MyEpicGame

MyEpicGame is a Solidity contract for an NFT game. The contract allows users to mint character NFTs, perform attacks on a boss character, and retrieve information about characters and the boss.

## Features

- Mint Character NFTs: Users can mint character NFTs by calling the `mintCharacterNFT` function, which mints a new NFT and assigns it to the caller's address.

- Attack Boss: Players can perform attacks on the boss character by calling the `attackboss` function. The boss will also attack the player in response. The results of the attack are emitted in the `AttackComplete` event.

- Character Attributes: The contract stores attributes for each character, including name, image URI, HP (Health Points), and attack damage.

- Boss Attributes: The contract also stores attributes for the boss character, including name, image URI, HP, and attack damage.

## Prerequisites

- Solidity compiler version 0.8.17
- OpenZeppelin library version 4.4.0
- Hardhat development environment

## Getting Started

1. Clone the repository:

git clone https://github.com/your-username/myepicgame.git

markdown
Copy code

2. Install dependencies:

npm install

markdown
Copy code

3. Compile the contracts:

npx hardhat compile

markdown
Copy code

4. Run the tests:

npx hardhat test

css
Copy code

5. Deploy the contract to a local development network:

npx hardhat run scripts/deploy.js --network development

markdown
Copy code

## Usage

To interact with the contract, you can use the provided functions:

- `mintCharacterNFT(uint256 _characterIndex)`: Mint a character NFT with the specified character index.

- `attackboss()`: Perform an attack on the boss character.

- `checkIfUserHasNFT()`: Check if the user owns an NFT and retrieve its attributes.

- `tokenURI(uint256 _tokenId)`: Get the token URI for a given token ID.

- `getAllDefaultcharacter()`: Get an array of all default character attributes.

- `getBoss()`: Get the attributes of the boss character.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
