// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import './ERC165.sol';

import './interfaces/IERC721.sol';

    /*

        A. NTF to point to an address
        b. keep^track of the token ids
        c. keep track of token owner addresses to token ids
        d. kee^p track of how many tokens an owner address has
        e. create event that emits a transfer logs - contract address, where it isbeing minted to
    */

contract ERC721 is ERC165, IERC721{





    //mapping from token id to the owner
    mapping(uint256 => address) private _tokenOwner;

    //mapping from owner to number of owned tokens
    mapping(address => uint256) private _OwnedTokensCount;


    //mapping from token id to approved addresses
    mapping(uint256 => address) private _tokenApprovals;


    constructor(){
        _registerInterfaces(bytes4(keccak256('balanceOf(bytes4)')^
        keccak256('ownerOf(bytes4)')^
        keccak256('transferFrom(bytes4)')));


    }
        

    /// @notice Count all NFTs assigned to an owner
    /// @dev NFTs assigned to the zero address are considered invalid, and this
    ///  function throws for queries about the zero address.
    /// @param _owner An address for whom to query the balance
    /// @return The number of NFTs owned by `_owner`, possibly zero
    function balanceOf(address _owner) override public view returns (uint256){
       require(_owner != address(0), "ERC721: owner query for non-existent token");
       return  _OwnedTokensCount[_owner];
    }

    /// @notice Find the owner of an NFT
    /// @dev NFTs assigned to zero address are considered invalid, and queries
    ///  about them do throw.
    /// @param _tokenId The identifier for an NFT
    /// @return The address of the owner of the NFT
    function ownerOf(uint256 _tokenId) override public view returns (address) {
        address owner = _tokenOwner[_tokenId];
        require( owner != address(0), "ERC721: address owner invalid");
        return owner;
    }


    function _exists(uint256 tokenId) internal view returns(bool){
        //set the address of the nft owner to check the mapping of the address from tokenOwner at the TokenId
        address owner = _tokenOwner[tokenId];
        //return the thruthiness that address is not zero
        return owner != address(0);
    }

    function _mint(address to, uint256 tokenId) internal virtual{

        require(to != address(0), "ERC721: minting to the zero address");

        require(!_exists(tokenId), "ERC724: token already minted");

        //we are adding a new address with a token id for minting
        _tokenOwner[tokenId] = to;
        _OwnedTokensCount[to] += 1;

        emit Transfer(address(0), to, tokenId);

    }


    
    function _transferFrom(address _from, address _to, uint256 _tokenId) internal {
        require(_to != address(0), "Error - ERC721 Transfer to the zero address");
        require(ownerOf(_tokenId) == _from, "Trying to transfer a token the address not ...");

        _OwnedTokensCount[_from] -= 1;
        _OwnedTokensCount[_to] += 1;

        _tokenOwner[_tokenId] = _to;

        emit Transfer(_from, _to, _tokenId);
    }

    /// @notice Transfer ownership of an NFT -- THE CALLER IS RESPONSIBLE
    ///  TO CONFIRM THAT `_to` IS CAPABLE OF RECEIVING NFTS OR ELSE
    ///  THEY MAY BE PERMANENTLY LOST
    /// @dev Throws unless `msg.sender` is the current owner, an authorized
    ///  operator, or the approved address for this NFT. Throws if `_from` is
    ///  not the current owner. Throws if `_to` is the zero address. Throws if
    ///  `_tokenId` is not a valid NFT.
    /// @param _from The current owner of the NFT
    /// @param _to The new owner
    /// @param _tokenId The NFT to transfer
    function transferFrom(address _from, address _to, uint256 _tokenId) override public {
        require(isApprovedOrOwner(msg.sender, _tokenId));
        _transferFrom(_from, _to, _tokenId);
    }

    //require that the person approving is the owner 
    //we are approving an address to a token(tokenId)
    //require that we cant approve sending tokens of the owner to the owner (current caller)
    //update the map ofthe approval addresses

    function approval(address _to, uint256 tokenId) public {
        address owner = ownerOf(tokenId);
        require(_to != owner, "Error, approval to current owner");
        require(msg.sender == owner, "Current caller is not the owner of token");

        _tokenApprovals[tokenId] = _to;
        emit Approval(owner,_to, tokenId);
    }


    function isApprovedOrOwner(address spender, uint256 tokenId) internal view returns (bool){
        require (_exists(tokenId), "Token doesn't exist");
        address owner = ownerOf(tokenId);

        return(spender == owner );
    }

}