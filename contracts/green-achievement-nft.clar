;; Green Achievement NFT Contract

(define-non-fungible-token green-achievement uint)

(define-data-var last-token-id uint u0)

(define-map token-metadata
  { token-id: uint }
  {
    achievement-type: (string-ascii 50),
    company: principal,
    description: (string-utf8 500),
    timestamp: uint
  }
)

(define-public (mint-achievement (achievement-type (string-ascii 50)) (description (string-utf8 500)))
  (let
    ((new-token-id (+ (var-get last-token-id) u1))
     (company tx-sender))
    (try! (nft-mint? green-achievement new-token-id company))
    (map-set token-metadata
      { token-id: new-token-id }
      {
        achievement-type: achievement-type,
        company: company,
        description: description,
        timestamp: block-height
      }
    )
    (var-set last-token-id new-token-id)
    (ok new-token-id)
  )
)

(define-public (transfer (token-id uint) (sender principal) (recipient principal))
  (begin
    (asserts! (is-eq tx-sender sender) (err u403))
    (nft-transfer? green-achievement token-id sender recipient)
  )
)

(define-read-only (get-token-metadata (token-id uint))
  (map-get? token-metadata { token-id: token-id })
)

(define-read-only (get-owner (token-id uint))
  (ok (nft-get-owner? green-achievement token-id))
)

(define-private (is-valid-achievement (company principal) (achievement-type (string-ascii 50)))
  true
)

