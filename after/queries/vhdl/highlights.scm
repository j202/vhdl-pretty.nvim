;; extends
;; Without this, Neovim discards this whole file: only one non-extending
;; base query is used per language, and nvim-treesitter already ships one
;; for vhdl.

;; nvim-treesitter's bundled query also captures these nodes as plain
;; @operator with no conceal; priority 105 makes ours win.

;; conceal only ever accepts a single character, but every token here is
;; two source characters wide. Each operator below is therefore matched
;; twice with #offset!: once concealing the first character to our symbol,
;; once concealing the second to a literal space - so the concealed result
;; stays exactly as wide as the source, and alignment is preserved.

;; signal_assignment is the only "<=" that means assign rather than compare.
((signal_assignment) @operator
  (#offset! @operator 0 0 0 -1)
  (#set! conceal "⇐")
  (#set! priority 105))

((signal_assignment) @operator
  (#offset! @operator 0 1 0 0)
  (#set! conceal " ")
  (#set! priority 105))

((variable_assignment) @operator
  (#offset! @operator 0 0 0 -1)
  (#set! conceal "≔")
  (#set! priority 105))

((variable_assignment) @operator
  (#offset! @operator 0 1 0 0)
  (#set! conceal " ")
  (#set! priority 105))

;; "=>" means the same thing (maps to / leads to) everywhere it appears.
(element_association
  "=>" @operator
  (#offset! @operator 0 0 0 -1)
  (#set! conceal "⇒")
  (#set! priority 105))
(element_association
  "=>" @operator
  (#offset! @operator 0 1 0 0)
  (#set! conceal " ")
  (#set! priority 105))

(association_element
  "=>" @operator
  (#offset! @operator 0 0 0 -1)
  (#set! conceal "⇒")
  (#set! priority 105))
(association_element
  "=>" @operator
  (#offset! @operator 0 1 0 0)
  (#set! conceal " ")
  (#set! priority 105))

(case_statement_alternative
  "=>" @operator
  (#offset! @operator 0 0 0 -1)
  (#set! conceal "⇒")
  (#set! priority 105))
(case_statement_alternative
  "=>" @operator
  (#offset! @operator 0 1 0 0)
  (#set! conceal " ")
  (#set! priority 105))

(case_generate_body
  "=>" @operator
  (#offset! @operator 0 0 0 -1)
  (#set! conceal "⇒")
  (#set! priority 105))
(case_generate_body
  "=>" @operator
  (#offset! @operator 0 1 0 0)
  (#set! conceal " ")
  (#set! priority 105))

((relational_operator) @operator
  (#eq? @operator "<=")
  (#offset! @operator 0 0 0 -1)
  (#set! conceal "≤")
  (#set! priority 105))
((relational_operator) @operator
  (#eq? @operator "<=")
  (#offset! @operator 0 1 0 0)
  (#set! conceal " ")
  (#set! priority 105))

((relational_operator) @operator
  (#eq? @operator ">=")
  (#offset! @operator 0 0 0 -1)
  (#set! conceal "≥")
  (#set! priority 105))
((relational_operator) @operator
  (#eq? @operator ">=")
  (#offset! @operator 0 1 0 0)
  (#set! conceal " ")
  (#set! priority 105))

((relational_operator) @operator
  (#eq? @operator "/=")
  (#offset! @operator 0 0 0 -1)
  (#set! conceal "≠")
  (#set! priority 105))
((relational_operator) @operator
  (#eq? @operator "/=")
  (#offset! @operator 0 1 0 0)
  (#set! conceal " ")
  (#set! priority 105))

;; Same three comparisons, but inside a VHDL-2008 `if/`elsif directive.
(conditional_analysis_relation
  "<=" @operator
  (#offset! @operator 0 0 0 -1)
  (#set! conceal "≤")
  (#set! priority 105))
(conditional_analysis_relation
  "<=" @operator
  (#offset! @operator 0 1 0 0)
  (#set! conceal " ")
  (#set! priority 105))

(conditional_analysis_relation
  ">=" @operator
  (#offset! @operator 0 0 0 -1)
  (#set! conceal "≥")
  (#set! priority 105))
(conditional_analysis_relation
  ">=" @operator
  (#offset! @operator 0 1 0 0)
  (#set! conceal " ")
  (#set! priority 105))

(conditional_analysis_relation
  "/=" @operator
  (#offset! @operator 0 0 0 -1)
  (#set! conceal "≠")
  (#set! priority 105))
(conditional_analysis_relation
  "/=" @operator
  (#offset! @operator 0 1 0 0)
  (#set! conceal " ")
  (#set! priority 105))
