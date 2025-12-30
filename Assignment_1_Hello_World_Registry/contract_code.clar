;; Hello World Registry Contract
;; Users can store and retrieve personalized greeting messages

;; Data Map
(define-map messages principal (string-utf8 500))

;; Error Constants
(define-constant ERR-EMPTY-MESSAGE (err u100))
(define-constant ERR-MESSAGE-NOT-FOUND (err u101))

;; Public Functions

;; Set or update a greeting message for the caller
;; @param message: the greeting message to store
;; @returns (ok true) on success
(define-public (set-message (message (string-utf8 500)))
    (begin
        (if (is-eq message u"")
            ERR-EMPTY-MESSAGE
            (begin
                (map-set messages tx-sender message)
                (ok true)
            )
        )
    )
)


;; Delete the caller's message
;; @returns (ok true) on success
(define-public (delete-message)
    (begin
        (map-delete messages tx-sender)
        (ok true)
    )
)

;; Read-only Functions

;; Get message for a specific principal
;; @param user: the principal to look up
;; @returns (some message) if found, none otherwise
(define-read-only (get-message (user principal))
    (map-get? messages user)
)

;; Get the caller's own message
;; @returns (some message) if found, none otherwise
(define-read-only (get-my-message)
    (get-message tx-sender)
)
