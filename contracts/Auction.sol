//SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;

contract Auction {
    address public owner;
    uint256 public highestBid;
    address public highestBidder;
    bool public isAuctionEnded;

    mapping(address => uint256) public bidAmount;
    mapping(string => uint256) public auctionStartTime;
    mapping(string => uint256) public auctionEndTime;
    mapping(address => string[]) private auctionOf;

    // mapping(string => uint256[]) private min_max_bid_amount;

    constructor() {
        owner = msg.sender;
    }

    event biddingInfo(address user, uint256 amount, string bidFor);

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

    function bidding(string memory _auctionFor) public payable {
        require(auctionStartTime[_auctionFor] > 0, "Not an aution");
        require(
            auctionStartTime[_auctionFor] < block.timestamp,
            "Invalid Time period"
        );
        require(msg.value > highestBid, "This bid has already done");
        require(msg.sender != owner, "Owner can't b the buyer");
        if (highestBid != 0) {
            bidAmount[highestBidder] += highestBid;
        }
        highestBidder = msg.sender;
        highestBid = msg.value;
        emit biddingInfo(msg.sender, msg.value, _auctionFor);
    }

    function endAuction(string memory _auctionFor) public {
        require(msg.sender == owner, "Caller is not the owner");
        require(
            auctionEndTime[_auctionFor] < block.timestamp,
            "Auction deadline not get completed"
        );
        require(!isAuctionEnded, "Auction has already ended");
        isAuctionEnded = true;
        payable(owner).transfer(highestBid);
    }
}
