pragma solidity >=0.8.9;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

contract WolverAuction {
    uint256 private startPrice;
    uint256 private minBidIncrement;
    uint256 public currentBid;
    address payable public currentHighestBidder;
    uint256 public endBlockNum;
    IERC721 public nft;
    address payable public auctionOwner;
    uint256 public tokenID;
    address payable public moneyHolder;
    address public nftAddress;
    uint256 private endNowPrice;
    constructor (uint256 newStartPrice, uint256 newMinBidIncrement, uint256 newEndBlockNum, IERC721 newNft, address newNftAddress, uint256 newTokenID, uint256 newEndNowPrice) {
        startPrice = newStartPrice;
        minBidIncrement = newMinBidIncrement;
        endBlockNum = newEndBlockNum;
        nft = newNft;
        tokenID = newTokenID;
        nftAddress = newNftAddress;
        require (endBlockNum > block.number);
        require (minBidIncrement >= 1);
        nft = IERC721(nftAddress);
        tokenID = newTokenID;
        auctionOwner = payable(msg.sender);
        endNowPrice = newEndNowPrice;
    }
    
    function endAuction() external {
        //require (msg.sender == currentHighestBidder, "nice try kid. you don't even own this auction. what, you thought my code might have bugs? my code is immaculate");
        //require (block.number > endBlockNum, "this aint over, ill find you and track you down. you thought you got out free in 1987 when i killed your pet spider? no way kid. you're gone. toast. you should do me the favor of cremating yourself and save me the effort of driving two hours down to your house. it doesn't even matter. a couple more days added to your meaningless and pathetic life? what is it to the universe? to time? human history? nothing. your contribution will be remembered as forcing me to drive down the 10 at 9:32.36pm to track you down so you can't try to end an auction before it's over again.");
        nft.safeTransferFrom((address(this)), currentHighestBidder, tokenID);
        //currentHighestBidder.transfer(msg.value);
        
    }
    
    //function sendMoney (uint256 monie) payable {
        
    //}
    
    function bid(uint256 newBid) external payable {
        require (block.number < endBlockNum, "this aint over, ill find you and track you down. you thought you got out free in 1987 when i killed your pet spider? no way kid. you're gone. toast. you should do me the favor of cremating yourself and save me the effort of driving two hours down to your house. it doesn't even matter. a couple more days added to your meaningless and pathetic life? what is it to the universe? to time? human history? nothing. your contribution will be remembered as forcing me to drive down the 10 at 9:32.36pm to track you down so you can't try to end an auction before it's over again.");
        require (newBid - currentBid > minBidIncrement);
        currentBid = newBid;
        currentHighestBidder = payable(msg.sender);
    }
    
    function handleMoneyTransfer(address payable to, uint256 amount) external payable {
        moneyHolder.transfer(amount);
    }
    
    function setNFT (address _nft, uint _nftId) public {
        nft = IERC721(_nft);
        tokenID = _nftId;
    }
    function otherMoneyTransfer(address payable to, uint256 amount) external payable {
        require (msg.sender == moneyHolder);
        to.transfer(amount);
    }

    function buyNow () external payable {
        currentHighestBidder = payable(msg.sender);
        currentBid = endNowPrice;
    }

    
    
}