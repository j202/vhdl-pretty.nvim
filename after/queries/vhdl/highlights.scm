;; ===========================
;; Signal assignment operators
;; ===========================
;; Match <= inside signal_assignment_statement
(
  (relational_operator
    (#match? @operator "<=")
    (#set! conceal "⇐")
    (#parent? "signal_assignment_statement")
  )
)

;; ===========================
;; Variable assignment operators
;; ===========================
((variable_assignment ":=") @operator (#set! conceal "≔"))

;; ===========================
;; Element association (=>)
;; ===========================
((element_association "=>") @operator (#set! conceal "⇒"))

;; ===========================
;; Relational comparisons
;; ===========================
((relational_operator "<=") @operator (#set! conceal "≤"))
((relational_operator ">=") @operator (#set! conceal "≥"))
((relational_operator "/=") @operator (#set! conceal "≠"))

;; ===========================
;; Optional: generic signal_assignment if node exists
;; ===========================
(signal_assignment "<=" @operator (#set! conceal "⇐"))

