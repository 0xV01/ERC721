const keccak256 = require("keccak256");
const {MerkleTree} = require("merkletreejs");


//Enter here the addresses that you want to whitlist
let whitlistedAddresses = [
    "0x5c6B0f7Bf3E7ce046039Bd8FABdfD3f9F5021678",
    "0x03C6FcED478cBbC9a4FAB34eF9f40767739D1Ff7"
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
