
;; Two-party escrow where buyer deposits and can release to seller or refund

;; Data Variables
(define-data-var escrow-count uint u0)

;; Constants for escrow status
(define-constant STATUS-PENDING u1)
(define-constant STATUS-COMPLETED u2)
(define-constant STATUS-REFUNDED u3)

;; Data Maps
(define-map escrows
    uint
    {
        buyer: principal,
        seller: principal,
        amount: uint,
        status: uint,
        created-at: uint
    }
)

;; Error Constants
(define-constant ERR-NOT-BUYER (err u400))
(define-constant ERR-NOT-FOUND (err u401))
(define-constant ERR-NOT-PENDING (err u402))
(define-constant ERR-TRANSFER-FAILED (err u403))
(define-constant ERR-INVALID-AMOUNT (err u404))

;; Public Functions

;; Create an escrow and deposit STX
(define-public (create-escrow (seller principal) (amount uint))
  (begin
    (asserts! (> amount u0) ERR-INVALID-AMOUNT)
    (let ((escrow-id (+ (var-get escrow-count) u1)))
      (begin
        ;; Transfer STX from buyer to contract
        (try! (stx-transfer? amount tx-sender (as-contract tx-sender)))
        ;; Store escrow details
        (map-set escrows escrow-id
          {
            buyer: tx-sender,
            seller: seller,
            amount: amount,
            status: STATUS-PENDING,
            created-at: stacks-block-height
          }
        )
        ;; Increment escrow count
        (var-set escrow-count escrow-id)
        (ok escrow-id)
      )
    )
  )
)

;; Buyer releases funds to seller
(define-public (release-funds (escrow-id uint))
  (let ((escrow (unwrap! (map-get? escrows escrow-id) ERR-NOT-FOUND)))
    (begin
      (asserts! (is-eq (get buyer escrow) tx-sender) ERR-NOT-BUYER)
      (asserts! (is-eq (get status escrow) STATUS-PENDING) ERR-NOT-PENDING)
      ;; Transfer STX from contract to seller
      (try! (as-contract (stx-transfer? (get amount escrow) tx-sender (get seller escrow))))
      ;; Update status to completed
      (map-set escrows escrow-id
        {
          buyer: (get buyer escrow),
          seller: (get seller escrow),
          amount: (get amount escrow),
          status: STATUS-COMPLETED,
          created-at: (get created-at escrow)
        }
      )
      (ok true)
    )
  )
)

;; Buyer refunds their own STX
(define-public (refund (escrow-id uint))
  (let ((escrow (unwrap! (map-get? escrows escrow-id) ERR-NOT-FOUND)))
    (begin
      (asserts! (is-eq (get buyer escrow) tx-sender) ERR-NOT-BUYER)
      (asserts! (is-eq (get status escrow) STATUS-PENDING) ERR-NOT-PENDING)
      ;; Transfer STX from contract back to buyer
      (try! (as-contract (stx-transfer? (get amount escrow) tx-sender (get buyer escrow))))
      ;; Update status to refunded
      (map-set escrows escrow-id
        {
          buyer: (get buyer escrow),
          seller: (get seller escrow),
          amount: (get amount escrow),
          status: STATUS-REFUNDED,
          created-at: (get created-at escrow)
        }
      )
      (ok true)
    )
  )
)

;; Read-only Functions

;; Get escrow details
(define-read-only (get-escrow (escrow-id uint))
  (ok (map-get? escrows escrow-id))
)

;; Get total number of escrows created
(define-read-only (get-escrow-count)
  (ok (var-get escrow-count))
)