# Assignment 4: Simple Escrow Contract

## Student Information
- Name: Prince Isaac
- Date: 2025-12-29

## Contract Overview

This contract implements a two-party escrow system. A buyer deposits STX for a specific seller. Funds are securely held until the buyer either releases them to the seller or requests a refund. Escrow states prevent unauthorized access and double-spending.

## Assumptions Made

- Only the buyer can release or refund the escrowed funds.
- Escrows are all-or-nothing; partial withdrawals are not supported.
- Escrow IDs are tracked externally by users.
- STX transfers always succeed when called correctly.
- No automatic expiry or dispute resolution; buyer must manually act.

## Design Decisions and Tradeoffs

### Decision 1: Buyer-only authorization
- **What I chose:** Only the buyer can release or refund escrow.
- **Why:** Ensures that sellers cannot prematurely withdraw funds.
- **Tradeoff:** Seller cannot act if buyer becomes unresponsive; requires trust in the buyer to finalize transactions.

### Decision 2: Escrow state machine
- **What I chose:** Escrows have three states: pending, completed, refunded.
- **Why:** Prevents double-spending and enforces correct workflow.
- **Tradeoff:** Slightly more complex logic, but increases safety and clarity.

### Decision 3: Incremental escrow IDs
- **What I chose:** Each new escrow gets a sequential ID stored in `escrow-count`.
- **Why:** Provides a simple, collision-free way to reference escrows.
- **Tradeoff:** Users must track escrow IDs; cannot rely on automatic lookup by parties.

## How to Use This Contract

### Function: create-escrow
- **Purpose:** Buyer creates a new escrow and deposits STX.
- **Parameters:** 
  - `seller`: Seller's principal
  - `amount`: Amount of STX to deposit
- **Returns:** `(ok escrow-id)`
- **Example:**
```clarity
(contract-call? .contract-code create-escrow 'ST1PQ... 'u1000)

##Known Limitations

-Only buyers can act on an escrow; sellers cannot force release.

-Escrows are all-or-nothing; no partial withdrawals.

-Contract does not support multi-sig or arbitration.

-Escrow IDs must be tracked by users; incorrect IDs will fail.

-No built-in service fee or commission mechanism.

-Cannot recover STX attached to incorrect escrow ID.

-No automatic expiry; inactive escrows require manual action by buyer.


##Future Improvements

-Introduce partial withdrawals.

-Add service fees or commissions.

-Multi-party approval or dispute resolution.

-Automatic expiry or forced refunds for inactive escrows.

##Testing Notes

-Created multiple escrows successfully between different buyers and sellers.

-Verified that only the buyer can release or refund funds.

-Tested double release/refund prevention.

-Checked get-escrow and get-escrow-count return correct values.

-Attempted invalid operations (wrong caller, wrong escrow ID) to confirm errors are thrown.