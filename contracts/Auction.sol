//SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;

contract Auction {
    address public owner;
    // string public auctionFor;

    mapping(address => uint256) public bidAmount;
    mapping(string => uint256) public auctionStartTime;
    mapping(string => uint256) public auctionEndTime;
    mapping(address => string[]) private auctionOf;

    constructor() {
        owner = msg.sender;
    }

    function inititalize(string memory _auctionFor, uint256 deadline) public {
        require(msg.sender == owner, "only owner can initialize the auction");
        require(
            deadline > block.timestamp,
            "Deadline should be greater then current time"
        );
        auctionOf[msg.sender].push(_auctionFor);
        auctionStartTime[_auctionFor] = block.timestamp;
        auctionEndTime[_auctionFor] = deadline;
    }

    function getAuctions() public view returns (string[] memory) {
        return auctionOf[owner];
    }

    function bidding()public payable {}

    function endAuction()public {}

    function settleMent()public {}
}
