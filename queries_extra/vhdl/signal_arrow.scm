;; Appended to the vhdl highlights query by setup(), only once the arrow
;; font has been built. U+F8F0 is the mirrored arrow; the "=" becomes a
;; blank so the arrow can spill into that cell.
;; signal_assignment is the only "<=" that means assign rather than compare.
((signal_assignment) @operator
  (#offset! @operator 0 0 0 -1)
  (#set! conceal "")
  (#set! priority 105))

((signal_assignment) @operator
  (#offset! @operator 0 1 0 0)
  (#set! conceal " ")
  (#set! priority 105))
