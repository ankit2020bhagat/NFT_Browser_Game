// const { token } = require("@project-serum/anchor/dist/cjs/utils");
const { ethers } = require("hardhat");
const { verify } = require("../utils/verify");
async function main() {
  const [...players] = await ethers.getSigners();
  const nftContract = await ethers.getContractFactory("MyEpicGame");
  const name = ["Leo", "Aang", "Pikachu"];
  image = [
    "QmVx79jpJTCvh9B8M6ZNucB4ehxLJyZVNsVqSfrwLwSKCG", // Images
    "QmetNRFG8t55zndy9WDBZfLcW37FGSQYELYAt3poiRWTbL",
    "QmRippRQfe5zwRwudtwEy1YjXYpnQ1pt7dKXNcfu66moUS",
  ];
  const hp = [100, 200, 300];
  const attack = [100, 50, 25];
  const bossName = "Elon Musk";
  const bossImage = "https://i.imgur.com/AksR0tt.png";
  const bossHp = 10000;
  const bossAttack = 50;

  const deployContract = await nftContract.deploy(
    name,
    image,
    hp,
    attack,
    bossName, // Boss name
    bossImage, // Boss image
    bossHp, // Boss hp
    bossAttack // Boss attack damage
  );
  await deployContract.deployed();
  console.log("Contract Address:", deployContract.address);
  await deployContract.deployTransaction.wait(5);
  await verify(deployContract.address, [
    name,
    image,
    hp,
    attack,
    bossName,
    bossImage,
    bossHp,
    bossAttack,
  ]);
}

const runMain = async () => {
  try {
    await main();
    process.exit(0);
  } catch (error) {
    console.log(error);
  }
};
runMain();
//0x55F7840A48441351891E1bf9E12286A1c924A451
