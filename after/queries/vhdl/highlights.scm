;; extends

;; Without ";; extends" above, Neovim treats this file as a competing base
;; query and silently discards it outright, since nvim-treesitter already
;; ships its own highlights.scm for vhdl (only one non-extending base file
;; is ever used per language). This was why nothing here ever took effect.
;;
;; nvim-treesitter's own bundled vhdl highlights.scm captures these same
;; operator nodes as plain @operator with no conceal. Since it and this
;; file both apply, give ours a higher priority so its conceal actually
;; wins the display instead of being masked by the un-concealed match.

;; ===========================
;; Signal assignment operator (<=)
;; ===========================
;; signal_assignment is a bare terminal node (its own text is "<="),
;; distinct from relational_operator, so no disambiguation is needed.
((signal_assignment) @operator
  (#set! conceal "⇐")
  (#set! priority 105))

;; ===========================
;; Variable assignment operator (:=)
;; ===========================
;; variable_assignment is likewise a bare terminal node (text ":=").
((variable_assignment) @operator
  (#set! conceal "≔")
  (#set! priority 105))

;; ===========================
;; Element association (=>)
;; ===========================
;; Capture just the "=>" token, not the whole association.
(element_association
  "=>" @operator
  (#set! conceal "⇒")
  (#set! priority 105))

;; ===========================
;; Relational comparisons
;; ===========================
;; relational_operator is also a bare terminal covering several operators,
;; so match its text to pick which one to conceal.
((relational_operator) @operator
  (#eq? @operator "<=")
  (#set! conceal "≤")
  (#set! priority 105))

((relational_operator) @operator
  (#eq? @operator ">=")
  (#set! conceal "≥")
  (#set! priority 105))

((relational_operator) @operator
  (#eq? @operator "/=")
  (#set! conceal "≠")
  (#set! priority 105))
