// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import './interfaces/IERC165.sol';


contract ERC165 is IERC165{

         // hash tables to  keep track of contract fingerbprint data of byte function conversions
        mapping(bytes4 => bool) private _supportedInterfaces;
        
        constructor(){
            _registerInterfaces(bytes4(keccak256('supportsInterface(bytes4)')));
        }
        

        function supportsInterface(bytes4 interfaceId) external override view returns (bool){
            return _supportedInterfaces[interfaceId];
        }

        //registering the interface (comes from within)
        function _registerInterfaces(bytes4 interfaceId) public {
            require(interfaceId != 0xffffffff, 'ERC165: Invalid Interface');
            _supportedInterfaces[interfaceId] = true;

        }
    

}