; Signal assignment (<=)
(signal_assignment "<=" @vhdl.assign.signal)
(#set! conceal "⇐")

; Variable assignment (:=)
(variable_assignment ":=" @vhdl.assign.variable)
(#set! conceal "≔")

; Element association (=>)
(element_association "=>" @vhdl.assoc)
(#set! conceal "⇒")

; Relational operators
(relational_operator "<=" @vhdl.compare)
(#set! conceal "≤")

(relational_operator ">=" @vhdl.compare)
(#set! conceal "≥")

(relational_operator "/=" @vhdl.compare)
(#set! conceal "≠")

