// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@openzeppelin/contracts/token/ERC1155/IERC1155.sol";
import "@openzeppelin/contracts/token/ERC1155/utils/ERC1155Receiver.sol";

    /////////////////////////////////////////////////////////////////////////
    //                          Contract NFT-Staker                        //
    /////////////////////////////////////////////////////////////////////////

contract NftStaker {

    /////////////////////////////////////////////////////////////////////////
    //                          IERC1155 Type variable                     //
    /////////////////////////////////////////////////////////////////////////

    IERC1155 public parentNFT;

    /////////////////////////////////////////////////////////////////////////
    //                          Structure                                  //
    /////////////////////////////////////////////////////////////////////////

    struct Stake {
        uint256 tokenId;
        uint256 amount;
        uint256 timestamp;
    }


    /////////////////////////////////////////////////////////////////////////
    //               Map staker address to stake details                   //
    /////////////////////////////////////////////////////////////////////////

    mapping(address => Stake) public stakes;

    /////////////////////////////////////////////////////////////////////////
    //               Map staker to total staking time                   //
    /////////////////////////////////////////////////////////////////////////

    mapping(address => uint256) public stakingTime;  

    /////////////////////////////////////////////////////////////////////////
    //                            Constructor                              //
    /////////////////////////////////////////////////////////////////////////  

    constructor() {
        parentNFT = IERC1155(0xd8b934580fcE35a11B58C6D73aDeE468a2833fa8); // Change it to your NFT contract addr
    }


    /////////////////////////////////////////////////////////////////////////
    //                      Function to stake NFT                          //
    /////////////////////////////////////////////////////////////////////////

    function stake(uint256 _tokenId, uint256 _amount) public {
        stakes[msg.sender] = Stake(_tokenId, _amount, block.timestamp); 
        parentNFT.safeTransferFrom(msg.sender, address(this), _tokenId, _amount, "0x00");
    } 


    /////////////////////////////////////////////////////////////////////////
    //                      Function to Unstake NFT                          //
    /////////////////////////////////////////////////////////////////////////

    function unstake() public {
        parentNFT.safeTransferFrom(address(this), msg.sender, stakes[msg.sender].tokenId, stakes[msg.sender].amount, "0x00");
        stakingTime[msg.sender] += (block.timestamp - stakes[msg.sender].timestamp);
        delete stakes[msg.sender];
    }      

    /////////////////////////////////////////////////////////////////////////
    //                Function to Make Contract Receiver                   //
    /////////////////////////////////////////////////////////////////////////

     function onERC1155Received(
        address operator,
        address from,
        uint256 id,
        uint256 value,
        bytes calldata data
    ) external pure returns (bytes4) {
        return bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"));
    }

}




////////////////////////////     End     ////////////////////////////////////