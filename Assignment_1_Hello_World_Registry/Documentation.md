# Assignment 1: Hello World Registry

## Student Information
- Name: Prince Isaac
- Date: 2025-12-30

## Contract Overview

This contract implements a simple registry on the Stacks blockchain where users can store, retrieve, update, and delete personalized greeting messages. Each message is mapped to the user’s principal address using a Clarity map.

## Assumptions Made

- Each user can only manage their own message.
- Messages must not be empty strings.
- The maximum message length is limited to 500 UTF-8 characters.
- Once a message is deleted, it is permanently removed from storage.
- Anyone can read messages stored by any user.

## Design Decisions and Tradeoffs

### Decision 1: Use tx-sender as the map key
- **What I chose:** Used `tx-sender` as the key for storing messages.
- **Why:** This ensures that each user owns and controls their own message without needing extra parameters.
- **Tradeoff:** Users cannot set or modify messages on behalf of others, even if desired.

### Decision 2: Use optional return type for reads
- **What I chose:** Used `map-get?` which returns an optional value.
- **Why:** This is idiomatic in Clarity and safely represents missing data.
- **Tradeoff:** Callers must handle `none` cases when a message does not exist.

### Decision 3: Simple empty string validation
- **What I chose:** Rejected empty strings using `(is-eq message "")`.
- **Why:** Prevents meaningless messages from being stored.
- **Tradeoff:** Does not trim whitespace; messages with only spaces are technically allowed.

## How to Use This Contract

### Function: set-message
- **Purpose:** Sets or updates the caller’s greeting message.
- **Parameters:** 
  - `message`: The greeting text to store.
- **Returns:** `(ok true)` on success, or `(err u100)` if the message is empty.
- **Example:**
```clarity
(contract-call? .contract-code set-message "Hello, Stacks!")
