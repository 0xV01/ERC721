const keccak256 = require("keccak256");
const {MerkleTree} = require("merkletreejs");


//Enter here the addresses that you want to whitlist
let whitlistedAddresses = [
    "0X5B38DA6A701C568545DCFCB03FCB875F56BEDDC4",
    "0X5A641E5FB72A2FD9137312E7694D42996D689D99",
    "0XDCAB482177A592E424D1C8318A464FC922E8DE40",
    "0X6E21D37E07A6F7E53C7ACE372CEC63D4AE4B6BD0",
    "0X09BAAB19FC77C19898140DADD30C4685C597620B",
    "0XCC4C29997177253376528C05D3DF91CF2D69061A",
    "0xdD870fA1b7C4700F2BD7f44238821C26f7392148"
]

//Create a mapping with address => hashed address which will become the leafes in the tree
const leafNodes = whitlistedAddresses.map(addr => keccak256(addr));

//Create a merkle tree with the leafNodes and sort them
const merkleTree = new MerkleTree(leafNodes, keccak256, {sortPairs : true});

//Get the root of the merkle tree
const rootHash = merkleTree.getRoot();

//Debug printing
console.log('Whitelist Merkle Tree\n', merkleTree.toString());
console.log("Root Hash: ", rootHash.toString('hex'));


//How to validate if address is in Merkle tree 
//leafNodes[1] means the first address in the whitlistedAddresses
//On minting site receive wallet address then keccack256(theAddress)
const claimingAddress = leafNodes[1];

//We are getting the HexProof from the claimingAddress which will then be send to the smart contract which then will verify the hexProof.
const hexProof = merkleTree.getHexProof(claimingAddress);
console.log(hexProof);

//Is done in Smart Contract (only for testing)
console.log(merkleTree.verify(hexProof, claimingAddress, rootHash));
