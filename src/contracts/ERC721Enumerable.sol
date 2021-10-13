// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import './ERC721.sol';
import './interfaces/IERC721Enumerable.sol';

contract ERC721Enumerable is ERC721, IERC721Enumerable {

    uint256[] private _allTokens;

    //MAPPING from tokenId to position in _allTokens array
    mapping(uint256 => uint256) private  _allTokensIndex;

    // mapping of owner to list of all owner token ids
    mapping(address => uint256[]) private _ownedTokens;

    //mapping from token ID to  index of the owner tokens list
    mapping(uint256 => uint256) private _ownedTokensIndex;


    
    constructor(){
        _registerInterfaces(bytes4(keccak256('tokenByIndex(bytes4)')^
        keccak256('tokenOfOwnerByIndex(bytes4)')^
        keccak256('totalSupply(bytes4)')));
    }


    function _mint(address to, uint256 tokenId) internal override(ERC721) {
        super._mint(to, tokenId);
        // 2things ! 
        //1 . add tokens to the owner
        //2. all tokens to our totalsupply - to all tokens

        _addTokensToAllTokenEnumeration(tokenId);
        _addTokensToOwnerEnumeration(to , tokenId);

    }

    //add token to the _alltokens array and set the position of the token indexes
    function _addTokensToAllTokenEnumeration(uint256 tokenId) private {
        _allTokensIndex[tokenId] = _allTokens.length;
        _allTokens.push(tokenId);
    }

    function _addTokensToOwnerEnumeration(address to, uint256 tokenId) private {
        
        _ownedTokens[to].push(tokenId);

        _ownedTokensIndex[tokenId] = _ownedTokens[to].length;

    }


    function tokenByIndex(uint256 index) public override view returns(uint256){
        require(index < totalSupply(), 'global index is out of bounds');
        return _allTokens[index];
    }

    function tokenOfOwnerByIndex(address owner, uint256 index) public override  view returns(uint256) {
        require (index < balanceOf(owner),'owner index is out of bounds');
        return _ownedTokens[owner][index];
    }

    /// @notice Count NFTs tracked by this contract
    /// @return A count of valid NFTs tracked by this contract, where each one of
    ///  them has an assigned and queryable owner not equal to the zero address
 
    function totalSupply() public override view returns (uint256){
        return _allTokens.length;
    }

}