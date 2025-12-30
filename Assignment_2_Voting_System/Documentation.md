# Assignment 2: Simple Voting System

## Student Information
- Name: Prince Isaac
- Date: 2025-12-29

## Contract Overview
This contract allows users to create proposals and vote. Each user may vote only once per proposal. Voting periods are enforced via an `end-height` provided when creating the proposal. The contract prevents double-voting and maintains vote tallies.

## Assumptions Made
- Proposal titles max 100 characters; descriptions max 500 characters.
- Voting duration is defined by `end-height` supplied by the creator.
- Votes cannot be changed or deleted.
- Each user can vote once per proposal.
- Anyone can read proposals, vote counts, and check voting status.

## Design Decisions and Tradeoffs

### Decision 1: Caller-supplied block heights
- **What I chose:** Require caller to provide `current-height` when voting and `end-height` when creating proposals.
- **Why:** Avoids unresolved `block-height` issues in Hiro Play, fully deployable.
- **Tradeoff:** Users must track the current block themselves.

### Decision 2: Composite key for votes
- **What I chose:** Use `{proposal-id, voter}` as the map key.
- **Why:** Prevents double-voting efficiently.
- **Tradeoff:** Slightly more storage per vote.

### Decision 3: Optional type handling via `match`
- **What I chose:** All read-only functions handle optional return values using `match`.
- **Why:** Ensures type safety on Hiro Epoch 3.2.
- **Tradeoff:** Slightly more verbose syntax, but fully safe.

## How to Use This Contract

### Function: create-proposal
- **Purpose:** Create a new proposal.
- **Parameters:** 
  - `title`: Proposal title
  - `description`: Proposal description
  - `end-height`: Block height when voting ends
- **Returns:** `(ok proposal-id)`
- **Example:**
```clarity
(contract-call? .contract-name create-proposal "New Policy" "Should we adopt it?" u1050)
