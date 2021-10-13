// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import './ERC165.sol';

import './interfaces/IERC721Metadata.sol';

contract ERC721Metadata is IERC721Metadata, ERC165 {
    string  private _name;
    string private _symbol;


    constructor(string memory named, string memory symbolified) {
        _name = named;
        _symbol = symbolified;
        _registerInterfaces(bytes4(keccak256('name(bytes4)')^
         keccak256('symbol(bytes4)') ));

    }


    function name() external view override returns (string memory){
        return _name;
    }

    
    function symbol() external view override returns (string memory){
        return _symbol;
    }
}