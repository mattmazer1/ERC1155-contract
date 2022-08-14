// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

import "@openzeppelin/contracts@4.7.2/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts@4.7.2/access/Ownable.sol";
import "@openzeppelin/contracts@4.7.2/token/ERC1155/extensions/ERC1155Supply.sol";
import "@openzeppelin/contracts@4.7.2/utils/cryptography/MerkleProof.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract CurrencyLogos is ERC1155, Ownable, ERC1155Supply {

    uint256 EthLogoMax;
    uint256 BitcoinLogoMax;
    uint256 public BitcoinCC;
    uint256 public EthCC;
    uint256 maxMintPP;
    mapping(address => bool) public minted;
    bool whiteListOn;
    uint256[] numbersIds;
    uint256[] mintAmount;
    bytes32 public merkleRoot;
    string public baseTokenURI;

    constructor()
        ERC1155("")
    {
        EthLogoMax=20;
        BitcoinLogoMax=15; 
        BitcoinCC=0;
        EthCC=0;
        maxMintPP=4;
        whiteListOn=false;
        numbersIds =[1,2];
        mintAmount =[4,4];
        baseTokenURI="ipfs://Qmdp7fTb7f1gTEYe6JkC22h4jScuwqxMgpAFFpeUmrk8Tq/";
        merkleRoot= 0x8382da4d2f70d03f30edb5bf388d46cc51c395f45ca7599ef979e3e7ae3525cc;
    }
    function activateWhitelist(bool activate)public onlyOwner{
        if(activate==true){
            whiteListOn=true;
        }else{
            whiteListOn=false;
        }
    }
    
    function updateMerkleRoot(bytes32 newRoot) public onlyOwner{
        merkleRoot = newRoot;
    }

      function setURI(string memory newURI) public onlyOwner {
        baseTokenURI = newURI;
    }

    function uri(uint256 tokenID) public view override returns (string memory) {
         string memory currentBaseURI = baseTokenURI;
        return string(
            abi.encodePacked(
                currentBaseURI,
                Strings.toString(tokenID),".json"));
    }
 

    function OwnerMint(address account, uint256 id, uint256 amount) public onlyOwner {
        require(id > 0 && id < 3,"ID doesn't exist");
        require(amount > 0,"Amount doesn't exist");
        if(id==1 && EthCC+amount > EthLogoMax){
            revert("You can't mint more than the max");
        }else if(id==1){
             _mint(account, id, amount,""); 
            EthCC+=amount;
        }
           if(id==2 && BitcoinCC+amount > BitcoinLogoMax){
            revert("You can't mint more than the max");
        }else if(id==2){
             _mint(account, id, amount,""); 
            BitcoinCC+=amount;
        }
    }

        function PublicMint(address account, uint256 id, uint256 amount) public {
        require(whiteListOn==false,"Whitelist is activated");
        require(minted[account]==false,"You can only mint once"); 
        require(id > 0 && id < 3,"ID doesn't exist");
        require(amount > 0,"Amount doesn't exist");
        require(amount<=maxMintPP,"You can't mint more than 4");
        if(id==1 && EthCC+amount > EthLogoMax){
            revert("You can't mint more than the max");
        }else if(id==1){
            _mint(account, id, amount,""); 
            EthCC+=amount;
            minted[account]=true;
        }
           if(id==2 && BitcoinCC+amount > BitcoinLogoMax){
            revert("You can't mint more than the max");
        }else if(id==2){
            _mint(account, id, amount,""); 
            BitcoinCC+=amount;
            minted[account]=true;
        }  
    }

        function WhitelistPublicMint(address account, bytes32[] calldata merkleProof, uint256 id, uint256 amount) public {
        bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
        require(
            MerkleProof.verify(merkleProof,merkleRoot, leaf),
            "Invalid Merkle Proof."
        );
        require(whiteListOn==true,"Whitelist is not activated");
        require(minted[account]==false,"You can only mint once"); 
        require(id > 0 && id < 3,"ID doesn't exist");
        require(amount>0,"Amount doesn't exist");
        require(amount<=maxMintPP,"You can't mint more than 4");
        if(id==1 && EthCC+amount > EthLogoMax){
            revert("You can't mint more than the max");
        }else if(id==1){
            _mint(account, id, amount,""); 
            EthCC+=amount;
            minted[account]=true;
        }
           if(id==2 && BitcoinCC+amount > BitcoinLogoMax){
            revert("You can't mint more than the max");
        }else if(id==2){
            _mint(account, id, amount,""); 
            BitcoinCC+=amount;
            minted[account]=true;
        }  
    }

    function OwnerMintBatch(address to, uint256[] calldata amounts)public onlyOwner  {
        uint num1 = amounts[0];
        uint num2 = amounts[1];
        require(num1 > 0 && num2 > 0,"Amounts doesn't exist");
        require(amounts.length<3 && amounts.length>0,"Invalid ids");
        require(EthCC+num1 < EthLogoMax || BitcoinCC+num2 < BitcoinLogoMax,"You can't mint more than the max" );
               _mintBatch(to, numbersIds, amounts, "");
               EthCC+=num1;
               BitcoinCC+=num2;  
    }
    
    function PublicMintBatch(address to)public {
        require(whiteListOn==false,"Whitelist is actived");
        require(minted[to]==false,"You can only mint once"); 
        require(EthCC+4 < EthLogoMax || BitcoinCC+4 < BitcoinLogoMax,"You can't mint more than the max" );
        _mintBatch(to, numbersIds, mintAmount, "");
        minted[to]=true;
        EthCC+=4;
        BitcoinCC+=4;  
    }

      function WhitelistPublicMintBatch(address to,bytes32[] calldata merkleProof)public {
          bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
        require(
            MerkleProof.verify( merkleProof,merkleRoot, leaf),
            "Invalid Merkle Proof."
        );
        require(whiteListOn==true,"Whitelist is not activated");
        require(minted[to]==false,"You can only mint once");
        require(EthCC+4 < EthLogoMax || BitcoinCC+4 < BitcoinLogoMax,"You can't mint more than the max" );
        _mintBatch(to, numbersIds, mintAmount, "");
        minted[to]=true;
        EthCC+=4;
        BitcoinCC+=4;  
    }

     function AirdropTokens(address [] calldata owners, uint256 id, uint256 amount ) public onlyOwner {
        require(id > 0 && id < 3,"ID doesn't exist");
        require(amount>0,"Amount doesn't exist");
         if(id==1 && EthCC+amount > EthLogoMax){
            revert("You can't mint more than the max");
        }else if(id==2 && BitcoinCC+amount > BitcoinLogoMax){
            revert("You can't mint more than the max");
        } 
        for(uint256 i = 0; i < owners.length; i++) {
            _mint(owners[i], id, amount, "");
            if(id==1){
            EthCC+=amount;
            }else if(id==2){
            BitcoinCC+=amount; 
        }  
        if(EthCC>EthLogoMax || BitcoinCC>BitcoinLogoMax){
            revert("Airdrop exceeds max amount");
        }
        }
     
    }

        function BatchAirdropTokens(address[] calldata owners, uint256[] calldata ids, uint256[] calldata amounts) public onlyOwner {
        uint num1 = amounts[0];
        uint num2 = amounts[1];
        uint id1 = ids[0];
        uint id2 = ids[1];
        require(num1 > 0 && num2 > 0,"Amounts doesn't exist");
        require(id1==1 && id2==2,"ID doesn't exist");
        require(ids.length<3,"ID doesn't exist"); 
        require(ids.length>0,"ID doesn't exist"); 
         if(EthCC+num1 > EthLogoMax || BitcoinCC+num2 > BitcoinLogoMax){
            revert("You can't mint more than the max");
        }  
        for(uint256 i = 0; i < owners.length; i++) {
            _mintBatch(owners[i], ids, amounts, "");
            EthCC+=num1;
            BitcoinCC+=num2;  
        if(EthCC>EthLogoMax || BitcoinCC>BitcoinLogoMax){
            revert("Airdrop exceeds max");
        }
        }
         
    }

    function _beforeTokenTransfer(address operator, address from, address to, uint256[] memory ids, uint256[] memory amounts, bytes memory data)
        internal
        override(ERC1155, ERC1155Supply)
    {
        super._beforeTokenTransfer(operator, from, to, ids, amounts, data);
    }
}

