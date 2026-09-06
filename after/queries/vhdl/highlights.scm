;; extends
;; Without this, Neovim discards this whole file: only one non-extending
;; base query is used per language, and nvim-treesitter already ships one
;; for vhdl.

;; nvim-treesitter's bundled query also captures these nodes as plain
;; @operator with no conceal; priority 105 makes ours win.

;; signal_assignment is the only "<=" that means assign rather than compare.
((signal_assignment) @operator
  (#set! conceal "⇐")
  (#set! priority 105))

((variable_assignment) @operator
  (#set! conceal "≔")
  (#set! priority 105))

;; "=>" means the same thing (maps to / leads to) everywhere it appears.
(element_association
  "=>" @operator
  (#set! conceal "⇒")
  (#set! priority 105))

(association_element
  "=>" @operator
  (#set! conceal "⇒")
  (#set! priority 105))

(case_statement_alternative
  "=>" @operator
  (#set! conceal "⇒")
  (#set! priority 105))

(case_generate_body
  "=>" @operator
  (#set! conceal "⇒")
  (#set! priority 105))

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

;; Same three comparisons, but inside a VHDL-2008 `if/`elsif directive.
(conditional_analysis_relation
  "<=" @operator
  (#set! conceal "≤")
  (#set! priority 105))

(conditional_analysis_relation
  ">=" @operator
  (#set! conceal "≥")
  (#set! priority 105))

(conditional_analysis_relation
  "/=" @operator
  (#set! conceal "≠")
  (#set! priority 105))
