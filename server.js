const express = require("express");
const app = express();
const PORT = process.env.PORT || 3001;

const { MerkleTree } = require("merkletreejs");
const keccak256 = require("keccak256");

const addresses = require("./addresses.json");
const hashedAddresses = addresses.map((addr) => keccak256(addr));
const merkleTree = new MerkleTree(hashedAddresses, keccak256, {
	sortPairs: true,
});

app.get("/proof/:address", (req, res) => {
	try {
		const hashedAddress = keccak256(req.params.address);
		const hexProof = merkleTree.getHexProof(hashedAddress);
		res.send(hexProof);
	} catch (error) {
		res.status(500).json({ message: error.message });
	}
});

app.listen(PORT, () => {
	console.log(`Listening on port ${PORT}`);
});
