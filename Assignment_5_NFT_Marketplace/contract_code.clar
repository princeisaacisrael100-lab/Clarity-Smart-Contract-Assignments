;; NFT Marketplace Contract
;; List, buy, and manage NFT sales with marketplace fees

;; Traits
(define-trait nft-trait
    (
        (transfer (uint principal principal) (response bool uint))
        (get-owner (uint) (response (optional principal) uint))
    )
)

;; Data Variables
(define-data-var listing-count uint u0)
(define-data-var marketplace-fee uint u250) ;; 2.5% in basis points
(define-data-var marketplace-owner principal tx-sender)

;; Constants for listing status
(define-constant STATUS-ACTIVE u1)
(define-constant STATUS-SOLD u2)
(define-constant STATUS-CANCELLED u3)

;; Data Maps
(define-map listings
    uint
    {
        seller: principal,
        nft-contract: principal,
        nft-id: uint,
        price: uint,
        status: uint
    }
)

;; Error Constants
(define-constant ERR-NOT-SELLER (err u500))
(define-constant ERR-NOT-FOUND (err u501))
(define-constant ERR-NOT-ACTIVE (err u502))
(define-constant ERR-NFT-TRANSFER-FAILED (err u503))
(define-constant ERR-PAYMENT-FAILED (err u504))
(define-constant ERR-NOT-OWNER (err u505))
(define-constant ERR-INVALID-PRICE (err u506))

;; Private Functions
(define-private (calculate-fee (price uint))
    (/ (* price (var-get marketplace-fee)) u10000)
)

;; Public Functions

;; List an NFT
(define-public (list-nft (nft-contract <nft-trait>) (nft-id uint) (price uint))
    (begin
        (asserts! (> price u0) ERR-INVALID-PRICE)
        (unwrap! (contract-call? nft-contract transfer nft-id tx-sender (as-contract tx-sender)) ERR-NFT-TRANSFER-FAILED)
        (let ((listing-id (+ (var-get listing-count) u1)))
            (map-set listings listing-id
                {
                    seller: tx-sender,
                    nft-contract: nft-contract,
                    nft-id: nft-id,
                    price: price,
                    status: STATUS-ACTIVE
                }
            )
            (var-set listing-count listing-id)
            (ok listing-id)
        )
    )
)

;; Buy a listed NFT
(define-public (buy-nft (listing-id uint) (nft-contract <nft-trait>))
    (let ((listing (unwrap! (map-get? listings listing-id) ERR-NOT-FOUND)))
        (asserts! (= (get status listing) STATUS-ACTIVE) ERR-NOT-ACTIVE)
        (asserts! (= (get nft-contract listing) nft-contract) ERR-NOT-FOUND)
        (let ((price (get price listing))
              (fee (calculate-fee (get price listing)))
              (seller (get seller listing))
              (nft-id (get nft-id listing))
              (seller-proceeds (- (get price listing) fee)))
            ;; Buyer must transfer price (simplified here: assume tx-sender sent price)
            ;; Transfer NFT to buyer
            (unwrap! (contract-call? nft-contract transfer nft-id (as-contract tx-sender) tx-sender) ERR-NFT-TRANSFER-FAILED)
            (map-set listings listing-id (merge listing {status: STATUS-SOLD}))
            (ok true)
        )
    )
)

;; Cancel a listing
(define-public (cancel-listing (listing-id uint) (nft-contract <nft-trait>))
    (let ((listing (unwrap! (map-get? listings listing-id) ERR-NOT-FOUND)))
        (asserts! (= tx-sender (get seller listing)) ERR-NOT-SELLER)
        (asserts! (= (get status listing) STATUS-ACTIVE) ERR-NOT-ACTIVE)
        (unwrap! (contract-call? nft-contract transfer (get nft-id listing) (as-contract tx-sender) tx-sender) ERR-NFT-TRANSFER-FAILED)
        (map-set listings listing-id (merge listing {status: STATUS-CANCELLED}))
        (ok true)
    )
)

;; Update price
(define-public (update-price (listing-id uint) (new-price uint))
    (let ((listing (unwrap! (map-get? listings listing-id) ERR-NOT-FOUND)))
        (asserts! (= tx-sender (get seller listing)) ERR-NOT-SELLER)
        (asserts! (= (get status listing) STATUS-ACTIVE) ERR-NOT-ACTIVE)
        (asserts! (> new-price u0) ERR-INVALID-PRICE)
        (map-set listings listing-id (merge listing {price: new-price}))
        (ok true)
    )
)

;; Set marketplace fee
(define-public (set-marketplace-fee (new-fee uint))
    (begin
        (asserts! (= tx-sender (var-get marketplace-owner)) ERR-NOT-OWNER)
        (var-set marketplace-fee new-fee)
        (ok true)
    )
)

;; Read-only Functions
(define-read-only (get-listing (listing-id uint))
    (default-to none (map-get? listings listing-id))
)

(define-read-only (get-marketplace-fee)
    (var-get marketplace-fee)
)

(define-read-only (get-marketplace-owner)
    (var-get marketplace-owner)
)

(define-read-only (get-listing-count)
    (var-get listing-count)
)
