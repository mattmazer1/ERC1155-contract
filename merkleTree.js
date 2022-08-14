const { MerkleTree } = require("merkletreejs");
const keccak256 = require("keccak256");

const whiteListAddresses = [
	"0x5e84BDda5426F59Db64991157e081AE653FB0c6f",
	"0xB376A4f3266Ec6718fCd066bCa4d5ac62915f6f0",
	"0xe9748bD057d80f3890404C244201a27076bCc00B",
	"0x764416a220a5edb1c281267edE1A3b9c8E9FC6C5",
	"0x0f23C081b334fF656f0C5481aFfeCc029e41725b",
	"0x6123adEc57C44A1117F88E1791F7a88d8a7B9C1b",
	"0xB580a1F46386951fFA534f708B3220F3d22cCF58",
	"0xA4A12645ec45e5517a4db7E27DD80Df68dA44EC3",
	"0xB961c2203517A6bBf4c2c6BdFc219fE4841A797d",
	"0x088605896d2A7AC513F337E555712B4c041d3Bd6",
];

const leafNodes = whiteListAddresses.map((addr) => keccak256(addr));
const merkleTree = new MerkleTree(leafNodes, keccak256, { sortPairs: true });
const rootHash = merkleTree.getRoot();

console.log("Whitelist Merkle Tree\n", merkleTree.toString());
console.log("Root Hash: ", rootHash);

//const claimingAddress = leafNodes[0];

//const hexProof = merkleTree.getHexProof(claimingAddress);

//console.log(hexProof);
//console.log(merkleTree.verify(hexProof, claimingAddress, rootHash));
