// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "./libraries/Base64.sol";
// Helper functions OpenZeppelin provides.
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "hardhat/console.sol";

contract MyEpicGame
 is ERC721 {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    uint256 randNounce = 0;

    struct characterAttribute {
        uint256 characterIndex;
        string name;
        string imageUri;
        uint256 hp;
        uint256 maxhp;
        uint256 attackDamage;
    }

    mapping(uint256 => characterAttribute) public nftholderAttribute;

    struct Big_Boss {
        string name;
        string imageUri;
        uint256 hp;
        uint256 maxhp;
        uint256 attackDamage;
    }

    Big_Boss public boss;

    mapping(address => uint256) public nftholder;

    characterAttribute[] defaultCharacter;

    event CharacterNFTMinted (address sender,uint tokenId,uint characterIndex);

    event AttackComplete (address sender,uint newBossHp,uint newPlayerHp);

    ///plarer have 0 Hp
    error plrinsuffientHp();

    ///Boss have 0 Hp
    error bossinsuffientHp();

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

    function getRandomInt(uint256 modulus) public returns (uint256) {
        randNounce++;

        return
            uint256(
                keccak256(
                    abi.encodePacked(block.timestamp, msg.sender, randNounce)
                )
            ) % modulus;
    }

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

    function tokenURI(uint256 _tokenId)
        public
        view
        override
        returns (string memory)
    {
        characterAttribute memory CharacterAttribute = nftholderAttribute[
            _tokenId
        ];

        string memory strhp = Strings.toString(CharacterAttribute.hp);
        string memory strmaxhp = Strings.toString(CharacterAttribute.maxhp);
        string memory strAttackDamage = Strings.toString(
            CharacterAttribute.attackDamage
        );

        string memory json = Base64.encode(
            abi.encodePacked(
                '{"name":"',
                CharacterAttribute.name,
                "--NFT #: ",
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
        );
        string memory output = string(
            abi.encodePacked("data:application/json;base64,", json)
        );
        return output;
    }
    
    function checkIfUserHasNFT() external view returns(characterAttribute memory){
        uint userNFTtokenId = nftholder[msg.sender];

        if(userNFTtokenId>0){
           return nftholderAttribute[userNFTtokenId];
        }
        else{
            characterAttribute memory emptyStruct;
            return emptyStruct;
        }
    }
    function getAllDefaultcharacter() public view returns(characterAttribute[] memory){
        return defaultCharacter;
    }

    function getBoss() external view returns(Big_Boss memory)  {
        return boss;
    }

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
            console.log("Boss is dead!!");
        } else {
            if (getRandomInt(10) > 5) {
                console.log("Random Integer ",getRandomInt(10));
                boss.hp = boss.hp - player.attackDamage;
                console.log(
                    "Player %s attack boss.New  boss Hp :",
                    player.name,
                    boss.hp
                );
            }
            else{
                console.log("%s player missed!!",player.name);
            }
        }

        if (player.hp <= boss.attackDamage) {
            player.hp = 0;
        } else {
            player.hp = player.hp - boss.attackDamage;
        }

        console.log(
            "Boss attack on player %s .New Player Hp:",
            player.name,
            player.hp
        );

        emit AttackComplete(msg.sender, boss.hp,  player.hp);
    }
}
