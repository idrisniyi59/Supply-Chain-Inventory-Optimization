;; Entity Verification Contract
;; Validates supply chain participants

(define-data-var admin principal tx-sender)

;; Entity types: 1=Supplier, 2=Manufacturer, 3=Distributor, 4=Retailer
(define-map entities
  { entity-id: (string-ascii 32) }
  {
    owner: principal,
    name: (string-ascii 64),
    entity-type: uint,
    verified: bool,
    active: bool
  }
)

(define-read-only (get-entity (entity-id (string-ascii 32)))
  (map-get? entities { entity-id: entity-id })
)

(define-public (register-entity
    (entity-id (string-ascii 32))
    (name (string-ascii 64))
    (entity-type uint))
  (begin
    (asserts! (is-none (get-entity entity-id)) (err u1)) ;; Entity ID already exists
    (asserts! (and (>= entity-type u1) (<= entity-type u4)) (err u2)) ;; Invalid entity type

    (ok (map-set entities
      { entity-id: entity-id }
      {
        owner: tx-sender,
        name: name,
        entity-type: entity-type,
        verified: false,
        active: true
      }
    ))
  )
)

(define-public (verify-entity (entity-id (string-ascii 32)))
  (begin
    (asserts! (is-eq tx-sender (var-get admin)) (err u3)) ;; Not authorized
    (match (get-entity entity-id)
      entity (ok (map-set entities
                  { entity-id: entity-id }
                  (merge entity { verified: true })
                ))
      (err u4) ;; Entity not found
    )
  )
)

(define-public (deactivate-entity (entity-id (string-ascii 32)))
  (begin
    (match (get-entity entity-id)
      entity (begin
        (asserts! (or (is-eq tx-sender (var-get admin))
                      (is-eq tx-sender (get owner entity)))
                  (err u3)) ;; Not authorized
        (ok (map-set entities
              { entity-id: entity-id }
              (merge entity { active: false })
            ))
      )
      (err u4) ;; Entity not found
    )
  )
)

(define-public (transfer-entity (entity-id (string-ascii 32)) (new-owner principal))
  (begin
    (match (get-entity entity-id)
      entity (begin
        (asserts! (is-eq tx-sender (get owner entity)) (err u3)) ;; Not authorized
        (ok (map-set entities
              { entity-id: entity-id }
              (merge entity { owner: new-owner })
            ))
      )
      (err u4) ;; Entity not found
    )
  )
)

(define-read-only (is-verified-entity (entity-id (string-ascii 32)))
  (match (get-entity entity-id)
    entity (and (get verified entity) (get active entity))
    false
  )
)
