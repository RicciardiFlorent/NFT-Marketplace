// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


/// @title ERC-721 Non-Fungible Token Standard
/// @dev See https://eips.ethereum.org/EIPS/eip-721
///  Note: the ERC-165 identifier for this interface is 0x80ac58cd.
interface IERC721{

    event Transfer(address indexed _from, address indexed _to, uint256 indexed _tokenId);


    event Approval(address indexed _owner, address indexed _approved, uint256 indexed _tokenId);

 

    function balanceOf(address _owner) external view returns (uint256);


    function ownerOf(uint256 _tokenId) external view returns (address);


    //function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes data) external payable;


    //function safeTransferFrom(address _from, address _to, uint256 _tokenId) external payable;

    function transferFrom(address _from, address _to, uint256 _tokenId) external ;


    //function setApprovalForAll(address _operator, bool _approved) external;


    //function getApproved(uint256 _tokenId) external view returns (address);

   // function isApprovedForAll(address _owner, address _operator) external view returns (bool);
}
