// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "./libraries/Base64.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "hardhat/console.sol";

/**
 * @title MyEpicGame
 * @dev A contract for an NFT game.
 */

contract MyEpicGame is ERC721 {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    /**
     * @dev Error thrown when player has insufficient HP.
     */
    error plrinsuffientHp();
    /**
     * @dev Error thrown when boss has insufficient HP.
     */
    error bossinsuffientHp();

    /**
     * @dev Event emitted when a character NFT is minted.
     */
    event CharacterNFTMinted(
        address indexed sender,
        uint indexed tokenId,
        uint indexed characterIndex
    );
    /**
     * @dev Event emitted when an attack is complete.
     */
    event AttackComplete(
        address indexed sender,
        uint indexed newBossHp,
        uint indexed newPlayerHp
    );

    /**
     * @dev Struct to store character attributes.
     */
    struct characterAttribute {
        uint256 characterIndex;
        string name;
        string imageUri;
        uint256 hp;
        uint256 maxhp;
        uint256 attackDamage;
    }

    /**
     * @dev Struct to store Big Boss attributes.
     */
    struct Big_Boss {
        string name;
        string imageUri;
        uint256 hp;
        uint256 maxhp;
        uint256 attackDamage;
    }

    Big_Boss public boss;
    mapping(uint256 => characterAttribute) public nftholderAttribute;
    mapping(address => uint256) public nftholder;

    characterAttribute[] defaultCharacter;
    uint256 randNounce = 0;

    /**
     * @dev Contract constructor.
     * @param characterName Array of character names.
     * @param characterImageUri Array of character image URIs.
     * @param characterHp Array of character HP values.
     * @param characterAttackDmg Array of character attack damage values.
     * @param bossName Name of the boss.
     * @param bossimageUri Image URI of the boss.
     * @param bossHp HP of the boss.
     * @param boosAttackDamage Attack damage of the boss.
     */
    constructor(
        string[] memory characterName,
        string[] memory characterImageUri,
        uint256[] memory characterHp,
        uint256[] memory characterAttackDmg,
        string memory bossName,
        string memory bossimageUri,
        uint256 bossHp,
        uint256 boosAttackDamage
    ) ERC721("Heros", "Hero") {
        boss = Big_Boss({
            name: bossName,
            imageUri: bossimageUri,
            hp: bossHp,
            maxhp: bossHp,
            attackDamage: boosAttackDamage
        });

        console.log(
            "Done initializing boss %s w/ HP %s, img  %s",
            boss.name,
            boss.hp,
            boss.imageUri
        );

        for (uint256 i = 0; i < characterName.length; i++) {
            defaultCharacter.push(
                characterAttribute({
                    characterIndex: i,
                    name: characterName[i],
                    imageUri: characterImageUri[i],
                    hp: characterHp[i],
                    maxhp: characterHp[i],
                    attackDamage: characterAttackDmg[i]
                })
            );

            characterAttribute memory c = defaultCharacter[i];

            console.log(
                "Done initializing %s w/ HP %s, img %s",
                c.name,
                c.hp,
                c.imageUri
            );
        }
        _tokenIds.increment();
    }

    /**
     * @dev Mint a character NFT.
     * @param _characterIndex The index of the character to mint.
     */
    function mintCharacterNFT(uint256 _characterIndex) external {
        uint256 newItemId = _tokenIds.current();

        _safeMint(msg.sender, newItemId);

        nftholderAttribute[newItemId] = characterAttribute({
            characterIndex: _characterIndex,
            name: defaultCharacter[_characterIndex].name,
            imageUri: defaultCharacter[_characterIndex].imageUri,
            hp: defaultCharacter[_characterIndex].hp,
            maxhp: defaultCharacter[_characterIndex].maxhp,
            attackDamage: defaultCharacter[_characterIndex].attackDamage
        });

        console.log(
            "Minted NFT w/ tokenId %s and characterIndex %s",
            newItemId,
            _characterIndex
        );

        nftholder[msg.sender] = newItemId;

        _tokenIds.increment();

        emit CharacterNFTMinted(msg.sender, newItemId, _characterIndex);
    }

    /**
     * @dev Get the token URI for a given tokenId.
     * @param _tokenId The ID of the token.
     * @return The token URI as a string.
     */
    function tokenURI(
        uint256 _tokenId
    ) public view override returns (string memory) {
        characterAttribute memory CharacterAttribute = nftholderAttribute[
            _tokenId
        ];

        string memory strhp = Strings.toString(CharacterAttribute.hp);
        string memory strmaxhp = Strings.toString(CharacterAttribute.maxhp);
        string memory strAttackDamage = Strings.toString(
            CharacterAttribute.attackDamage
        );

        string memory json = Base64.encode(
            bytes(
                string(
                    abi.encodePacked(
                        '{"name": "',
                        CharacterAttribute.name,
                        " -- NFT #: ",
                        Strings.toString(_tokenId),
                        '", "description": "An epic NFT", "image": "ipfs://',
                        CharacterAttribute.imageUri,
                        '", "attributes": [ { "trait_type": "Health Points", "value": ',
                        strhp,
                        ', "max_value":',
                        strmaxhp,
                        '}, { "trait_type": "Attack Damage", "value": ',
                        strAttackDamage,
                        "} ]}"
                    )
                )
            )
        );
        string memory output = string(
            abi.encodePacked("data:application/json;base64,", json)
        );
        return output;
    }

    /**
     * @dev Check if the user owns an NFT.
     * @return The character attributes of the user's NFT, or an empty struct if the user doesn't have an NFT.
     */
    function checkIfUserHasNFT()
        external
        view
        returns (characterAttribute memory)
    {
        uint userNFTtokenId = nftholder[msg.sender];

        if (userNFTtokenId > 0) {
            return nftholderAttribute[userNFTtokenId];
        } else {
            characterAttribute memory emptyStruct;
            return emptyStruct;
        }
    }

    /**
     * @dev Get all default characters.
     * @return An array of default character attributes.
     */
    function getAllDefaultcharacter()
        public
        view
        returns (characterAttribute[] memory)
    {
        return defaultCharacter;
    }

    function getBoss() external view returns (Big_Boss memory) {
        return boss;
    }

    /**
     * @dev Perform an attack on the boss.
     */
    function attackboss() public {
        uint256 tokenId = nftholder[msg.sender];

        characterAttribute storage player = nftholderAttribute[tokenId];

        console.log(
            "\nPlayer chaeracter %s about to attack.Has /w %s Hp and %s Attack Damage",
            player.name,
            player.hp,
            player.attackDamage
        );

        console.log(
            "\n Boss %s has /w %s Hp and %s Ad",
            boss.name,
            boss.hp,
            boss.attackDamage
        );

        if (player.hp <= 0) {
            revert plrinsuffientHp();
        }

        if (boss.hp <= 0) {
            revert bossinsuffientHp();
        }

        if (boss.hp < player.attackDamage) {
            boss.hp = 0;
        } else {
            boss.hp = boss.hp - player.attackDamage;
        }

        // Allow boss to attack player.
        if (player.hp < boss.attackDamage) {
            player.hp = 0;
        } else {
            player.hp = player.hp - boss.attackDamage;
        }

        // Console for ease.
        console.log("Player attacked boss. New boss hp: %s", boss.hp);
        console.log("Boss attacked player. New player hp: %s\n", player.hp);
        console.log(
            "Boss attack on player %s .New Player Hp:",
            player.name,
            player.hp
        );

        emit AttackComplete(msg.sender, boss.hp, player.hp);
    }
}
