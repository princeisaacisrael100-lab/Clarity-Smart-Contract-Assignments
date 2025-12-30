# Assignment 3: Time-locked Wallet

## Student Information
- Name: Prince Isaac
- Date: 2025-12-29
- Contract Address: tx sender

## Contract Overview
This contract allows users to deposit STX tokens with a lock period specified in blocks. Users can withdraw their funds only after the unlock height is reached. The contract also allows extending the lock period and tracks the total STX locked.

## Assumptions Made
- Amounts are in micro-STX (1 STX = 1,000,000 micro-STX).  
- Users cannot withdraw partially; withdrawals are all-or-nothing.  
- Unlock heights are strictly enforced; funds cannot be accessed early.  
- Users may extend but not shorten their lock period.  
- Total locked STX is updated correctly on deposits and withdrawals.  

## Design Decisions and Tradeoffs

### Decision 1: Separate maps for balances and unlock heights
- **What I chose:** Use `balances` and `unlock-heights` maps keyed by principal.  
- **Why:** Simplifies access to each user's locked amount and unlock height.  
- **Tradeoff:** Slightly higher storage cost per user but simplifies logic and safety.

### Decision 2: Use `block-height` from Clarity environment
- **What I chose:** Use Clarity’s `block-height` to calculate unlocks and validate withdrawals.  
- **Why:** Ensures predictable timing based on blockchain state.  
- **Tradeoff:** Users must be aware of current block height to plan withdrawals.

### Decision 3: Validations for deposits and withdrawals
- **What I chose:** Require deposit amounts > 0 and enforce unlock height before withdrawals.  
- **Why:** Prevents errors, zero-value transactions, and early withdrawals.  
- **Tradeoff:** Slightly more code per transaction but ensures contract safety.

## How to Use This Contract

### Function: deposit
- **Purpose:** Deposit STX with a lock period.  
- **Parameters:** 
  - `amount`: Amount of STX in micro-STX  
  - `lock-blocks`: Number of blocks to lock funds  
- **Returns:** `(ok true)` on success  
- **Example:**
```clarity
(contract-call? .time-lock-wallet deposit u1000000 u50)
