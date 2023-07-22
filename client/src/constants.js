const CONTRACT_ADDRESS = "0xBad065221063f6996d63De151014E1be1B1EE9F3";

/*
 * Add this method and make sure to export it on the bottom!
 */
const transformCharacterData = (characterData) => {
  return {
    name: characterData.name,
    imageURI: characterData.imageUri,
    hp: characterData.hp,
    maxHp: characterData.maxhp,
    attackDamage: characterData.attackDamage,
  };
};

export { CONTRACT_ADDRESS, transformCharacterData };
