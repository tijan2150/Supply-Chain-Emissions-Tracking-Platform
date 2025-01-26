;; Reduction Targets Contract

(define-map reduction-targets
  { company: principal }
  {
    baseline-year: uint,
    baseline-emissions: uint,
    target-year: uint,
    target-percentage: uint
  }
)

(define-public (set-reduction-target (baseline-year uint) (baseline-emissions uint) (target-year uint) (target-percentage uint))
  (let
    ((company tx-sender))
    (map-set reduction-targets
      { company: company }
      {
        baseline-year: baseline-year,
        baseline-emissions: baseline-emissions,
        target-year: target-year,
        target-percentage: target-percentage
      }
    )
    (ok true)
  )
)

(define-read-only (get-reduction-target (company principal))
  (map-get? reduction-targets { company: company })
)

(define-read-only (is-target-achieved (company principal) (current-emissions uint))
  (let
    ((target (unwrap! (get-reduction-target company) (err u404))))
    (>= (* (- (get baseline-emissions target) current-emissions) u100)
        (* (get baseline-emissions target) (get target-percentage target)))
  )
)

