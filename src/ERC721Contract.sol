// SPDX-License-Identifier: MIT
pragma solidity 0.8.14;

import "openzeppelin-contracts.git/contracts/token/ERC721/ERC721.sol";
import "openzeppelin-contracts.git/contracts/access/Ownable.sol";
import "openzeppelin-contracts.git/contracts/security/ReentrancyGuard.sol";
import "openzeppelin-contracts.git/contracts/utils/Counters.sol";
import "openzeppelin-contracts.git/contracts/utils/cryptography/MerkleProof.sol";

contract ERC721Contract is ERC721, Ownable, ReentrancyGuard{
    using Counters for Counters.Counter;

    Counters.Counter private tokenId;

    bytes32 public root;

    //The Max supply of NFTs that can be minted
    uint256 public maxSupply;

    //Price when minting an NFT
    uint256 public price;

    //link to the metadata hosted on IPFS
    string internal uri;

    //The revealed state of an Token
    bool public revealed = false;

    //The current state for minting (disables minting for whitlisted addresses too)
    bool public paused = true;

    //The presale state for minting (only Whitlisted addresses can mint)
    bool public presale = false;

    //Determines if an address already minted
    mapping(address => bool) public addressMinted;

    modifier mintable() {
        require(tokenId.current() < maxSupply, "All NFTs minted");
        require(!addressMinted[msg.sender], "Already Minted");
        _;
    }

    constructor(string memory _name, string memory _symbole, uint256 _maxSupply, uint256 _price, bytes32 _root) ERC721(_name, _symbole) {
        maxSupply = _maxSupply;
        price = _price;
        root = _root;
    }

    function mint() external payable mintable {
        require(!paused, "Minting paused");
        require(msg.value >= price, "Not enought Ether send");
        require(!addressMinted[msg.sender], "Already Minted");

        addressMinted[msg.sender] = true;
        tokenId.increment();

        _safeMint(msg.sender, tokenId.current());
    }

    function whitlistedMint(bytes32[] calldata _proof) external payable mintable {
        require(presale, "Presale didn't started");
        require(!addressMinted[msg.sender], "Already minted");

        //Check if address is in whitlist with Merkle tree
        bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
        require(MerkleProof.verify(_proof, root, leaf), "Not a part of Whitlist");
        addressMinted[msg.sender] = true;

        tokenId.increment();

        _safeMint(msg.sender, tokenId.current());


    }

    function setUri(string memory _uri) external onlyOwner {
        uri = _uri;
    }
    
    function setPrice(uint256 _price) external onlyOwner {
        price = _price;
    }

    function setReveal(bool _state) external onlyOwner {
        revealed = _state;
    }

    function setPaused(bool _state) external onlyOwner {
        paused = _state;    
    }

    function setPresale(bool _state) external onlyOwner {
        presale = _state;
    }

    function withdraw() external onlyOwner {
        (bool success, ) = msg.sender.call{value: address(this).balance}("");
        require(success, "failed to withdraw");
    }

    function _baseURI() internal view virtual override returns (string memory) {
        return uri;
    }
    
}
