# Assignment 5: NFT Marketplace

## Student Information
- Name: Prince Isaac
- Date: 2025-12-30

## Contract Overview
This contract allows users to list, buy, and manage NFT sales in a decentralized marketplace. Sellers can list NFTs with a price, buyers can purchase listed NFTs, and marketplace fees are collected for each transaction. Listings can be updated or cancelled by the seller before a sale occurs.

## Assumptions Made
- NFTs conform to SIP-009 standard with `transfer` and `get-owner`.
- Marketplace fee is fixed in basis points and applied to every sale.
- Only the seller can modify, cancel, or update listings.
- Buyers are responsible for sending correct STX when buying (simplified in contract).
- NFT ownership is verified via the trait before transfers.

## Design Decisions and Tradeoffs    

### Decision 1: Marketplace Fee Calculation
- **What I chose:** Store fee in basis points and calculate dynamically on purchase.
- **Why:** Makes it flexible and precise for fractional percentages.
- **Tradeoff:** Requires division; must check for rounding errors.

### Decision 2: NFT Escrow via Contract
- **What I chose:** NFTs are transferred to the contract upon listing and returned or sent to buyer.
- **Why:** Ensures secure custody until transaction completes.
- **Tradeoff:** Requires contract to have proper NFT transfer rights.

### Decision 3: Status Constants for Listings
- **What I chose:** Use STATUS-ACTIVE, STATUS-SOLD, STATUS-CANCELLED as constants.
- **Why:** Simple state machine to prevent double-selling.
- **Tradeoff:** Limits to single sale per listing; cannot relist same listing ID.

## How to Use This Contract

### Function: list-nft
- **Purpose:** List an NFT for sale.
- **Parameters:** 
  - `nft-contract`: NFT contract implementing SIP-009
  - `nft-id`: token ID of the NFT
  - `price`: listing price in STX
- **Returns:** `(ok listing-id)`
- **Example:**
```clarity
(contract-call? .nft-marketplace list-nft my-nft-contract u1 u1000000)


##Known Limitations

-Contract does not handle partial payments or auctions.

-Buyer payment is simplified; in production, STX transfers need proper validation.

-Cannot relist an NFT with the same listing ID once sold or cancelled.

-Marketplace fee rounding may slightly impact proceeds.

-Future Improvements

-Support auctions and bidding.

-Enable partial payments or escrow for large NFTs.

-Dynamic marketplace fee tiers based on NFT value or seller status.

-Batch listing creation.

##Testing Notes

-Created multiple NFT listings.

-Purchased listings and verified NFT ownership transfer.

-Cancelled listings and verified NFT returned to seller.

-Updated listing prices successfully.

-Tested edge cases: non-seller trying to cancel/update, buying sold or cancelled NFT.


##Security Checklist:


 -Verify NFT ownership before listing

 -Prevent double-spending of NFTs

 -Ensure atomic swaps (payment + NFT transfer together)

 -Validate all state transitions

 -Check for integer overflow in fee calculations

 -Only seller can modify their listings