;; Inventory Tracking Contract
;; Records stock levels for products across the supply chain

(define-map products
  { product-id: (string-ascii 32) }
  {
    name: (string-ascii 64),
    owner: principal,
    category: (string-ascii 32),
    created-at: uint
  }
)

(define-map inventory
  {
    entity-id: (string-ascii 32),
    product-id: (string-ascii 32)
  }
  {
    quantity: uint,
    min-threshold: uint,
    max-capacity: uint,
    last-updated: uint
  }
)

(define-map transactions
  { tx-id: (string-ascii 32) }
  {
    from-entity: (string-ascii 32),
    to-entity: (string-ascii 32),
    product-id: (string-ascii 32),
    quantity: uint,
    timestamp: uint
  }
)

;; Read functions
(define-read-only (get-product (product-id (string-ascii 32)))
  (map-get? products { product-id: product-id })
)

(define-read-only (get-inventory (entity-id (string-ascii 32)) (product-id (string-ascii 32)))
  (map-get? inventory { entity-id: entity-id, product-id: product-id })
)

(define-read-only (get-transaction (tx-id (string-ascii 32)))
  (map-get? transactions { tx-id: tx-id })
)

;; Write functions
(define-public (register-product
    (product-id (string-ascii 32))
    (name (string-ascii 64))
    (category (string-ascii 32)))
  (begin
    (asserts! (is-none (get-product product-id)) (err u1)) ;; Product already exists

    (ok (map-set products
      { product-id: product-id }
      {
        name: name,
        owner: tx-sender,
        category: category,
        created-at: block-height
      }
    ))
  )
)

(define-public (update-inventory
    (entity-id (string-ascii 32))
    (product-id (string-ascii 32))
    (quantity uint)
    (min-threshold uint)
    (max-capacity uint))
  (begin
    (asserts! (contract-call? .entity-verification is-verified-entity entity-id) (err u2)) ;; Entity not verified
    (asserts! (is-some (get-product product-id)) (err u3)) ;; Product does not exist
    (asserts! (<= quantity max-capacity) (err u4)) ;; Quantity exceeds max capacity

    (ok (map-set inventory
      { entity-id: entity-id, product-id: product-id }
      {
        quantity: quantity,
        min-threshold: min-threshold,
        max-capacity: max-capacity,
        last-updated: block-height
      }
    ))
  )
)

(define-public (record-transaction
    (tx-id (string-ascii 32))
    (from-entity (string-ascii 32))
    (to-entity (string-ascii 32))
    (product-id (string-ascii 32))
    (quantity uint))
  (begin
    (asserts! (is-none (get-transaction tx-id)) (err u1)) ;; Transaction ID already exists
    (asserts! (contract-call? .entity-verification is-verified-entity from-entity) (err u2)) ;; From entity not verified
    (asserts! (contract-call? .entity-verification is-verified-entity to-entity) (err u3)) ;; To entity not verified
    (asserts! (is-some (get-product product-id)) (err u4)) ;; Product does not exist

    ;; Update inventory for sender (decrease)
    (match (get-inventory from-entity product-id)
      from-inv (begin
        (asserts! (>= (get quantity from-inv) quantity) (err u5)) ;; Insufficient inventory
        (map-set inventory
          { entity-id: from-entity, product-id: product-id }
          (merge from-inv {
            quantity: (- (get quantity from-inv) quantity),
            last-updated: block-height
          })
        )
      )
      (err u6) ;; Sender inventory not found
    )

    ;; Update inventory for receiver (increase)
    (match (get-inventory to-entity product-id)
      to-inv (begin
        (asserts! (<= (+ (get quantity to-inv) quantity) (get max-capacity to-inv)) (err u7)) ;; Exceeds receiver capacity
        (map-set inventory
          { entity-id: to-entity, product-id: product-id }
          (merge to-inv {
            quantity: (+ (get quantity to-inv) quantity),
            last-updated: block-height
          })
        )
      )
      ;; If receiver doesn't have this product in inventory yet, create a new entry
      (err u8) ;; Receiver inventory not found
    )

    ;; Record the transaction
    (ok (map-set transactions
      { tx-id: tx-id }
      {
        from-entity: from-entity,
        to-entity: to-entity,
        product-id: product-id,
        quantity: quantity,
        timestamp: block-height
      }
    ))
  )
)
