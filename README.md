# Clarity Smart Contract Assignments - Starter Code Templates

## Submission Guidelines

### Repository Setup

**Students must fork the starter repository and complete assignments in their fork.**

#### Repository Structure

Your forked repository should maintain this structure:

```
clarity-smart-contract-assignments/
│
├── README.md (update with your name and progress)
│
├── Assignment_1_Hello_World_Registry/
│   ├── contract_code.clar
│   ├── Documentation.md
│   └── README.md
│
├── Assignment_2_Voting_System/
│   ├── contract_code.clar
│   ├── Documentation.md
│   └── README.md
│
├── Assignment_3_Timelock_Wallet/
│   ├── contract_code.clar
│   ├── Documentation.md
│   └── README.md
│
├── Assignment_4_Escrow_Contract/
│   ├── contract_code.clar
│   ├── Documentation.md
│   └── README.md
│
└── Assignment_5_NFT_Marketplace/
    ├── contract_code.clar
    ├── Documentation.md
    └── README.md
```

### Submission Process

1. **Fork** the starter repository provided by your instructor
2. **Clone** your forked repository to your local machine:
   ```bash
   git clone https://github.com/Codewithshagbaor/Clarity-Smart-Contract-Assignments.git
   https://github.com/princeisaacisrael100-lab/Clarity-Smart-Contract-Assignments.git
   ```

3. **Update** the main README.md (This) with your information:
   ```markdown
   # Clarity Smart Contract Assignments
   
   **Student Name:** Prince Isaac
   **Cohort:** 1
   **Submission Date:** 2025-12-30
   
   ## Progress Tracker
   - [x] Assignment 1: Hello World Registry
   - [x] Assignment 2: Voting System
   - [x] Assignment 3: Timelock Wallet
   - [x] Assignment 4: Escrow Contract
   - [x] Assignment 5: NFT Marketplace
   ```

4. **Complete** each assignment in its respective folder:
   - Write your contract code in `contract_code.clar`
   - Document your work in `Documentation.md`

5. **Commit** your work regularly with meaningful messages:
   ```bash
   git add Assignment_1_Hello_World_Registry/
   git commit -m "Complete Assignment 1: Hello World Registry"
   git push origin main
   ```

6. **Submit** by providing your repository URL when all assignments are complete

### File Requirements

**1. contract_code.clar**
- Must be a valid Clarity contract file
- Can be developed in the Clarity playground, then copied to repository
- Must include all required functions
- Should be properly commented

**2. Documentation.md**
- Must be in Markdown format
- Should include the following sections:

```markdown
# Assignment 1: Hello World Registry

## Student Information
- Name: Prince Isaac
- Date: 29-12-2025

---

## Contract Overview

The Hello World Registry contract allows users to store, retrieve, update, and delete a personalized text message associated with their blockchain principal. Each principal can only manage their own message, ensuring ownership and data isolation. The contract demonstrates basic Clarity concepts such as maps, principals, public functions, read-only functions, and safe state mutation.

---

## Assumptions Made

- Each principal can store **only one message** at a time.
- Messages are directly associated with `tx-sender`.
- Updating a message fully replaces the previous message.
- Once a message is deleted, it **cannot be recovered**.
- There is no global message registry; all messages are user-specific.
- Message content is assumed to be UTF-8 compatible text.

---

## Design Decisions and Tradeoffs

### Decision 1: Use `tx-sender` as the message owner
- **What I chose:** Messages are keyed by the sender’s principal.
- **Why:** This guarantees ownership without requiring explicit authentication logic.
- **Tradeoff:** Messages cannot be written or managed on behalf of another user.

---

### Decision 2: Single message per user
- **What I chose:** Each principal can store only one message.
- **Why:** Keeps the contract simple and aligned with introductory learning goals.
- **Tradeoff:** Users cannot store multiple messages or message history.

---

### Decision 3: Separate public and read-only functions
- **What I chose:** Used read-only functions for fetching messages and public functions for mutations.
- **Why:** Improves safety and clarity by separating state changes from queries.
- **Tradeoff:** Slightly more functions compared to a minimal implementation.

---

## How to Use This Contract

### Function: set-message
- **Purpose:** Stores or updates the caller’s message.
- **Parameters:**
  - `message` (string-utf8): The message to store
- **Returns:** `(ok true)` on success
- **Example:**
```clarity
(contract-call? .hello-world-registry set-message "Hello, Clarity!")

## Known Limitations

Does not support multiple messages per user.

No message length enforcement beyond Clarity limits.

Messages are not indexed or searchable globally.

No event logging for message changes.

## Future Improvements

Support multiple messages per user using IDs.

Add maximum message length validation.

Emit print events for create/update/delete actions.

Allow read-only access to other users’ messages.

## Testing Notes
Tested using Hiro Playground.

Verified message creation, retrieval, update, and deletion.

Confirmed that users cannot access or modify other users’ messages.

Confirmed delete removes message permanently.

Tested read-only functions for correctness without state mutation.
```

### Git Best Practices

- **Commit often**: Don't wait until all assignments are done
- **Write clear commit messages**: Describe what you changed and why
- **One assignment per commit**: Makes it easier to track progress
- **Don't commit sensitive data**: No private keys or personal information
- **Keep your fork updated**: Pull any updates from the original repository if needed

### Important Notes

- ✅ Fork the starter repository before beginning work
- ✅ Maintain the exact folder structure provided
- ✅ Commit your work regularly with clear messages
- ✅ You can develop in the playground, but code must be in the repository
- ✅ Documentation must explain your design choices, not just describe functions
- ✅ Update the main README.md with your progress
- ✅ Submit your repository URL when ready for grading
- ❌ Do not modify the folder names
- ❌ Do not delete or rename provided files
- ❌ Do not commit compiled files or deployment artifacts
- ❌ Do not wait until the last minute to commit everything

### Final Submission

When all assignments are complete:

1. **Verify** all files are committed and pushed to GitHub
2. **Double-check** that your repository is public (or accessible to instructor)
3. **Test** that your repository URL works in an incognito/private browser window
4. **Submit** your repository URL in the format:
   ```
   https://github.com/YOUR_USERNAME/clarity-smart-contract-assignments
   ```
5. Submission link will be provider in the group chat.
---

## Example Completed Documentation (check Assignment 1)

## Assignment Overview

### Assignment 1: Hello World Registry
A simple registry where users can store and retrieve personalized messages.

**Key Concepts:** Maps, principals, basic storage

### Assignment 2: Voting System
Create proposals and vote on them with one vote per user.

**Key Concepts:** Complex data structures, authorization, preventing double-voting

### Assignment 3: Timelock Wallet
Lock STX tokens that can only be withdrawn after a specified time.

**Key Concepts:** STX transfers, block-height conditions, time-based logic

### Assignment 4: Escrow Contract
Two-party escrow where buyer deposits and can release to seller or get refund.

**Key Concepts:** Multi-party authorization, state machines, financial flows

### Assignment 5: NFT Marketplace
List, buy, and manage NFT sales with marketplace fees.

**Key Concepts:** NFT traits, complex transactions, fee mechanics, custody

## Resources

- [Clarity Language Reference](https://docs.stacks.co/clarity)
- [Clarity Playground](https://platform.hiro.so/projects)
- [SIP-009 NFT Standard](https://github.com/stacksgov/sips)
- [Stacks Documentation](https://docs.stacks.co)

## Grading Criteria

- **Functionality** (40%): Does the contract work as specified?
- **Code Quality** (25%): Is the code clean, well-organized, and properly commented?
- **Security** (20%): Are edge cases handled? No obvious vulnerabilities?
- **Testing** (15%): Are test cases comprehensive and well-documented?

Good luck with your assignments! 🚀
