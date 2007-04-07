;; -*- Mode: LISP; Package: SYSTEM-INTERNALS; Base:8 -*-
;-- INITIAL SYMS  CADR VERSION
; FIELDS
(DEFPROP FUNCTION-SOURCE 1_26. CONS-LAP-SYM)
  (DEFPROP FUNCTION-SOURCE 1_31. CONS-LAP-ADDITIVE-CONSTANT)
(DEFPROP BYTE-SIZE (OR (BYTE-INSTRUCTION-P 1_5)
                       (DISPATCH-INSTRUCTION-P 1_5.)) CONS-LAP-SYM)
(DEFPROP BYTE-ROTATE 0 CONS-LAP-SYM)
(DEFPROP FUNCTION-DESTINATION 1_19. CONS-LAP-SYM)
(DEFPROP A-SOURCE-MULTIPLIER 1_32. CONS-LAP-SYM)
(DEFPROP M-SOURCE-MULTIPLIER 1_26. CONS-LAP-SYM)
(DEFPROP A-DESTINATION-MULTIPLIER 1_14. CONS-LAP-SYM)
(DEFPROP M-DESTINATION-MULTIPLIER 1_14. CONS-LAP-SYM)
(DEFPROP JUMP-ADDRESS-MULTIPLIER 1_12. CONS-LAP-SYM)
(DEFPROP DISPATCH-ADDRESS-MULTIPLIER 1_12. CONS-LAP-SYM)
(DEFPROP ALU-OP (FORCE-ALU 1_3) CONS-LAP-SYM)
(DEFPROP ALU-OUTPUT-BUS-SELECTOR-MULTIPLIER (FORCE-ALU 1_12.) CONS-LAP-SYM)

(DEFPROP ALU-INST (FORCE-ALU 0) CONS-LAP-SYM)
(DEFPROP DISPATCH (FORCE-DISPATCH 0) CONS-LAP-SYM)
(DEFPROP BYTE-INST (FORCE-BYTE 0) CONS-LAP-SYM)
(DEFPROP JUMP-INST (FORCE-JUMP 0) CONS-LAP-SYM)

(DEFPROP DISPATCH-ADVANCE-INSTRUCTION-STREAM 1_24. CONS-LAP-SYM)
(DEFPROP DISPATCH-PUSH-OWN-ADDRESS 1_25. CONS-LAP-SYM)

(SETQ SR-BIT 1_12.)
(DEFPROP SR-BIT (FORCE-BYTE 1_12.) CONS-LAP-SYM)
(DEFPROP MR-BIT (FORCE-BYTE 1_13.) CONS-LAP-SYM)

(DEFPROP ALU-CARRY-IN-ZERO (FORCE-ALU 0_2) CONS-LAP-SYM)
(DEFPROP ALU-CARRY-IN-ONE (FORCE-ALU 1_2) CONS-LAP-SYM)

(DEFPROP OUTPUT-SELECTOR-NORMAL
        (FIELD ALU-OUTPUT-BUS-SELECTOR-MULTIPLIER 1) CONS-LAP-SYM)
(DEFPROP OUTPUT-SELECTOR-RIGHTSHIFT-1
        (FIELD ALU-OUTPUT-BUS-SELECTOR-MULTIPLIER 2) CONS-LAP-SYM)
(DEFPROP OUTPUT-SELECTOR-LEFTSHIFT-1
        (FIELD ALU-OUTPUT-BUS-SELECTOR-MULTIPLIER 3) CONS-LAP-SYM)

(DEFPROP SHIFT-Q-LEFT (FORCE-ALU 1_0) CONS-LAP-SYM)
(DEFPROP SHIFT-Q-RIGHT (FORCE-ALU 2_0) CONS-LAP-SYM)
(DEFPROP LOAD-Q (FORCE-ALU 3_0) CONS-LAP-SYM)

(DEFPROP R-BIT 1_9. CONS-LAP-SYM)
(DEFPROP P-BIT 1_8. CONS-LAP-SYM)
(DEFPROP INHIBIT-XCT-NEXT-BIT 1_7. CONS-LAP-SYM)

(DEFPROP INVERT-JUMP-SENSE (FORCE-JUMP 1_6) CONS-LAP-SYM)

(DEFPROP JUMP-LESS-THAN-CONDITION 41 CONS-LAP-SYM)
(DEFPROP JUMP-LESS-CONDITION 41 CONS-LAP-SYM)
(DEFPROP JUMP-LESS-OR-EQUAL-CONDITION 42 CONS-LAP-SYM)
(DEFPROP JUMP-EQUAL-CONDITION 43 CONS-LAP-SYM)
(DEFPROP JUMP-GREATER-THAN-CONDITION
            (PLUS INVERT-JUMP-SENSE JUMP-LESS-OR-EQUAL-CONDITION) CONS-LAP-SYM)
(DEFPROP JUMP-GREATER-CONDITION
            (PLUS INVERT-JUMP-SENSE JUMP-LESS-OR-EQUAL-CONDITION) CONS-LAP-SYM)
(DEFPROP JUMP-GREATER-OR-EQUAL-CONDITION
            (PLUS INVERT-JUMP-SENSE JUMP-LESS-CONDITION) CONS-LAP-SYM)

(DEFPROP JUMP-ON-PAGE-FAULT-CONDITION 44 CONS-LAP-SYM)
(DEFPROP JUMP-ON-PAGE-FAULT-OR-INTERRUPT-PENDING-CONDITION 45 CONS-LAP-SYM)
(DEFPROP JUMP-ON-PAGE-FAULT-OR-INTERRUPT-PENDING-OR-SEQUENCE-BREAK-CONDITION 46 CONS-LAP-SYM)
(DEFPROP JUMP-ALWAYS 47 CONS-LAP-SYM)

(DEFPROP JUMP-ON-BIT-CONDITION 0 CONS-LAP-SYM)

;MISC FUNCTION CODES

(DEFPROP INSTRUCTION-STREAM 3_10. CONS-LAP-SYM)
(DEFPROP WRITE-DISPATCH-RAM (FORCE-DISPATCH 2_10.) CONS-LAP-SYM)
(DEFPROP HALT-CONS 1_10. CONS-LAP-SYM)

(DEFPROP I-LONG 1000000000000000 CONS-LAP-SYM)

; "AUGMENTED" INSTRUCTIONS
(DEFPROP JUMP-OP-XCT-NEXT JUMP-INST CONS-LAP-SYM)
(DEFPROP JUMP-OP (PLUS JUMP-INST INHIBIT-XCT-NEXT-BIT) CONS-LAP-SYM)

(DEFPROP JUMP-XCT-NEXT (PLUS JUMP-OP-XCT-NEXT JUMP-ALWAYS) CONS-LAP-SYM)
(DEFPROP JUMP (PLUS JUMP-OP JUMP-ALWAYS) CONS-LAP-SYM)

(DEFPROP CALL-XCT-NEXT (PLUS JUMP-XCT-NEXT P-BIT) CONS-LAP-SYM)
(DEFPROP CALL (PLUS JUMP P-BIT) CONS-LAP-SYM)

(DEFPROP POPJ-XCT-NEXT (PLUS JUMP-XCT-NEXT R-BIT) CONS-LAP-SYM)
(DEFPROP POPJ (PLUS JUMP R-BIT) CONS-LAP-SYM)

(DEFPROP JUMP-IF-BIT-SET (PLUS JUMP-OP JUMP-ON-BIT-CONDITION) CONS-LAP-SYM)
(DEFPROP JUMP-IF-BIT-CLEAR (PLUS JUMP-IF-BIT-SET INVERT-JUMP-SENSE) CONS-LAP-SYM)
(DEFPROP JUMP-IF-BIT-SET-XCT-NEXT (PLUS JUMP-OP-XCT-NEXT JUMP-ON-BIT-CONDITION)
         CONS-LAP-SYM)
(DEFPROP JUMP-IF-BIT-CLEAR-XCT-NEXT (PLUS JUMP-IF-BIT-SET-XCT-NEXT INVERT-JUMP-SENSE)
         CONS-LAP-SYM)

(DEFPROP CALL-IF-BIT-SET (PLUS JUMP-IF-BIT-SET P-BIT) CONS-LAP-SYM)
(DEFPROP CALL-IF-BIT-CLEAR (PLUS JUMP-IF-BIT-CLEAR P-BIT) CONS-LAP-SYM)
(DEFPROP CALL-IF-BIT-SET-XCT-NEXT (PLUS JUMP-IF-BIT-SET-XCT-NEXT P-BIT) CONS-LAP-SYM)
(DEFPROP CALL-IF-BIT-CLEAR-XCT-NEXT (PLUS JUMP-IF-BIT-CLEAR-XCT-NEXT P-BIT)
         CONS-LAP-SYM)

(DEFPROP POPJ-IF-BIT-SET (PLUS JUMP-IF-BIT-SET R-BIT) CONS-LAP-SYM)
(DEFPROP POPJ-IF-BIT-CLEAR (PLUS JUMP-IF-BIT-CLEAR R-BIT) CONS-LAP-SYM)
(DEFPROP POPJ-IF-BIT-SET-XCT-NEXT (PLUS JUMP-IF-BIT-SET-XCT-NEXT R-BIT) CONS-LAP-SYM)
(DEFPROP POPJ-IF-BIT-CLEAR-XCT-NEXT (PLUS JUMP-IF-BIT-CLEAR-XCT-NEXT R-BIT)
         CONS-LAP-SYM)

(DEFPROP JUMP-EQUAL (PLUS JUMP-OP JUMP-EQUAL-CONDITION) CONS-LAP-SYM)
(DEFPROP JUMP-NOT-EQUAL (PLUS JUMP-OP
                           (PLUS JUMP-EQUAL-CONDITION INVERT-JUMP-SENSE)) CONS-LAP-SYM)
(DEFPROP JUMP-EQUAL-XCT-NEXT (PLUS JUMP-OP-XCT-NEXT JUMP-EQUAL-CONDITION) CONS-LAP-SYM)
(DEFPROP JUMP-NOT-EQUAL-XCT-NEXT
                        (PLUS JUMP-OP-XCT-NEXT
                           (PLUS JUMP-EQUAL-CONDITION INVERT-JUMP-SENSE)) CONS-LAP-SYM)

(DEFPROP CALL-EQUAL (PLUS JUMP-EQUAL P-BIT) CONS-LAP-SYM)
(DEFPROP CALL-NOT-EQUAL (PLUS JUMP-NOT-EQUAL P-BIT) CONS-LAP-SYM)
(DEFPROP CALL-EQUAL-XCT-NEXT (PLUS JUMP-EQUAL-XCT-NEXT P-BIT) CONS-LAP-SYM)
(DEFPROP CALL-NOT-EQUAL-XCT-NEXT (PLUS JUMP-NOT-EQUAL-XCT-NEXT P-BIT) CONS-LAP-SYM)

(DEFPROP POPJ-EQUAL (PLUS JUMP-EQUAL R-BIT) CONS-LAP-SYM)
(DEFPROP POPJ-NOT-EQUAL (PLUS JUMP-NOT-EQUAL R-BIT) CONS-LAP-SYM)
(DEFPROP POPJ-EQUAL-XCT-NEXT (PLUS JUMP-EQUAL-XCT-NEXT R-BIT) CONS-LAP-SYM)
(DEFPROP POPJ-NOT-EQUAL-XCT-NEXT (PLUS JUMP-NOT-EQUAL-XCT-NEXT R-BIT) CONS-LAP-SYM)

(DEFPROP JUMP-LESS-THAN (PLUS JUMP-OP JUMP-LESS-THAN-CONDITION) CONS-LAP-SYM)
(DEFPROP JUMP-LESS-THAN-XCT-NEXT (PLUS JUMP-OP-XCT-NEXT JUMP-LESS-THAN-CONDITION)
         CONS-LAP-SYM)

(DEFPROP CALL-LESS-THAN (PLUS JUMP-LESS-THAN P-BIT) CONS-LAP-SYM)
(DEFPROP CALL-LESS-THAN-XCT-NEXT (PLUS JUMP-LESS-THAN-XCT-NEXT P-BIT) CONS-LAP-SYM)

(DEFPROP POPJ-LESS-THAN (PLUS JUMP-LESS-THAN R-BIT) CONS-LAP-SYM)
(DEFPROP POPJ-LESS-THAN-XCT-NEXT (PLUS JUMP-LESS-THAN-XCT-NEXT R-BIT) CONS-LAP-SYM)

(DEFPROP JUMP-GREATER-THAN (PLUS JUMP-OP JUMP-GREATER-THAN-CONDITION) CONS-LAP-SYM)
(DEFPROP JUMP-GREATER-THAN-XCT-NEXT
         (PLUS JUMP-OP-XCT-NEXT JUMP-GREATER-THAN-CONDITION) CONS-LAP-SYM)

(DEFPROP CALL-GREATER-THAN (PLUS JUMP-GREATER-THAN P-BIT) CONS-LAP-SYM)
(DEFPROP CALL-GREATER-THAN-XCT-NEXT
         (PLUS JUMP-GREATER-THAN-XCT-NEXT P-BIT) CONS-LAP-SYM)

(DEFPROP POPJ-GREATER-THAN (PLUS JUMP-GREATER-THAN R-BIT) CONS-LAP-SYM)
(DEFPROP POPJ-GREATER-THAN-XCT-NEXT
         (PLUS JUMP-GREATER-THAN-XCT-NEXT R-BIT) CONS-LAP-SYM)

(DEFPROP JUMP-LESS (PLUS JUMP-OP JUMP-LESS-CONDITION) CONS-LAP-SYM)
(DEFPROP JUMP-LESS-XCT-NEXT (PLUS JUMP-OP-XCT-NEXT JUMP-LESS-CONDITION)
         CONS-LAP-SYM)

(DEFPROP CALL-LESS (PLUS JUMP-LESS P-BIT) CONS-LAP-SYM)
(DEFPROP CALL-LESS-XCT-NEXT (PLUS JUMP-LESS-XCT-NEXT P-BIT) CONS-LAP-SYM)

(DEFPROP POPJ-LESS (PLUS JUMP-LESS R-BIT) CONS-LAP-SYM)
(DEFPROP POPJ-LESS-XCT-NEXT (PLUS JUMP-LESS-XCT-NEXT R-BIT) CONS-LAP-SYM)

(DEFPROP JUMP-GREATER (PLUS JUMP-OP JUMP-GREATER-CONDITION) CONS-LAP-SYM)
(DEFPROP JUMP-GREATER-XCT-NEXT
         (PLUS JUMP-OP-XCT-NEXT JUMP-GREATER-CONDITION) CONS-LAP-SYM)

(DEFPROP CALL-GREATER (PLUS JUMP-GREATER P-BIT) CONS-LAP-SYM)
(DEFPROP CALL-GREATER-XCT-NEXT
         (PLUS JUMP-GREATER-XCT-NEXT P-BIT) CONS-LAP-SYM)

(DEFPROP POPJ-GREATER (PLUS JUMP-GREATER R-BIT) CONS-LAP-SYM)
(DEFPROP POPJ-GREATER-XCT-NEXT
         (PLUS JUMP-GREATER-XCT-NEXT R-BIT) CONS-LAP-SYM)

(DEFPROP JUMP-GREATER-OR-EQUAL
         (PLUS JUMP-OP JUMP-GREATER-OR-EQUAL-CONDITION) CONS-LAP-SYM)
(DEFPROP JUMP-GREATER-OR-EQUAL-XCT-NEXT
         (PLUS JUMP-OP-XCT-NEXT JUMP-GREATER-OR-EQUAL-CONDITION) CONS-LAP-SYM)

(DEFPROP CALL-GREATER-OR-EQUAL (PLUS JUMP-GREATER-OR-EQUAL P-BIT) CONS-LAP-SYM)
(DEFPROP CALL-GREATER-OR-EQUAL-XCT-NEXT
         (PLUS JUMP-GREATER-OR-EQUAL-XCT-NEXT P-BIT) CONS-LAP-SYM)

(DEFPROP POPJ-GREATER-OR-EQUAL (PLUS JUMP-GREATER-OR-EQUAL R-BIT) CONS-LAP-SYM)
(DEFPROP POPJ-GREATER-OR-EQUAL-XCT-NEXT
         (PLUS JUMP-GREATER-OR-EQUAL-XCT-NEXT R-BIT) CONS-LAP-SYM)

(DEFPROP JUMP-LESS-OR-EQUAL (PLUS JUMP-OP JUMP-LESS-OR-EQUAL-CONDITION) CONS-LAP-SYM)
(DEFPROP JUMP-LESS-OR-EQUAL-XCT-NEXT
         (PLUS JUMP-OP-XCT-NEXT JUMP-LESS-OR-EQUAL-CONDITION) CONS-LAP-SYM)

(DEFPROP CALL-LESS-OR-EQUAL (PLUS JUMP-LESS-OR-EQUAL P-BIT) CONS-LAP-SYM)
(DEFPROP CALL-LESS-OR-EQUAL-XCT-NEXT
         (PLUS JUMP-LESS-OR-EQUAL-XCT-NEXT P-BIT) CONS-LAP-SYM)

(DEFPROP POPJ-LESS-OR-EQUAL (PLUS JUMP-LESS-OR-EQUAL R-BIT) CONS-LAP-SYM)
(DEFPROP POPJ-LESS-OR-EQUAL-XCT-NEXT
         (PLUS JUMP-LESS-OR-EQUAL-XCT-NEXT R-BIT) CONS-LAP-SYM)


(DEFPROP JUMP-IF-PAGE-FAULT (PLUS JUMP-OP JUMP-ON-PAGE-FAULT-CONDITION) CONS-LAP-SYM)
(DEFPROP JUMP-IF-PAGE-FAULT-XCT-NEXT
         (PLUS JUMP-OP-XCT-NEXT JUMP-ON-PAGE-FAULT-CONDITION) CONS-LAP-SYM)

(DEFPROP CALL-IF-PAGE-FAULT (PLUS JUMP-IF-PAGE-FAULT P-BIT) CONS-LAP-SYM)
(DEFPROP CALL-IF-PAGE-FAULT-XCT-NEXT
         (PLUS JUMP-IF-PAGE-FAULT-XCT-NEXT P-BIT) CONS-LAP-SYM)

(DEFPROP POPJ-IF-PAGE-FAULT (PLUS JUMP-IF-PAGE-FAULT R-BIT) CONS-LAP-SYM)
(DEFPROP POPJ-IF-PAGE-FAULT-XCT-NEXT
         (PLUS JUMP-IF-PAGE-FAULT-XCT-NEXT R-BIT) CONS-LAP-SYM)

(DEFPROP JUMP-IF-PAGE-FAULT-OR-INTERRUPT (PLUS JUMP-OP JUMP-ON-PAGE-FAULT-OR-INTERRUPT-PENDING-CONDITION) CONS-LAP-SYM)
(DEFPROP JUMP-IF-PAGE-FAULT-OR-INTERRUPT-XCT-NEXT
         (PLUS JUMP-OP-XCT-NEXT JUMP-ON-PAGE-FAULT-OR-INTERRUPT-PENDING-CONDITION) CONS-LAP-SYM)

(DEFPROP CALL-IF-PAGE-FAULT-OR-INTERRUPT (PLUS JUMP-IF-PAGE-FAULT-OR-INTERRUPT P-BIT) CONS-LAP-SYM)
(DEFPROP CALL-IF-PAGE-FAULT-OR-INTERRUPT-XCT-NEXT
         (PLUS JUMP-IF-PAGE-FAULT-OR-INTERRUPT-XCT-NEXT P-BIT) CONS-LAP-SYM)

(DEFPROP POPJ-IF-PAGE-FAULT-OR-INTERRUPT (PLUS JUMP-IF-PAGE-FAULT-OR-INTERRUPT R-BIT) CONS-LAP-SYM)
(DEFPROP POPJ-IF-PAGE-FAULT-OR-INTERRUPT-XCT-NEXT
         (PLUS JUMP-IF-PAGE-FAULT-OR-INTERRUPT-XCT-NEXT R-BIT) CONS-LAP-SYM)

;These really check for page fault, interrupt or sequence break,
;but that makes a hell of a name!
(DEFPROP JUMP-IF-SEQUENCE-BREAK (PLUS JUMP-OP JUMP-ON-PAGE-FAULT-OR-INTERRUPT-PENDING-OR-SEQUENCE-BREAK-CONDITION) CONS-LAP-SYM)
(DEFPROP JUMP-IF-SEQUENCE-BREAK-XCT-NEXT
         (PLUS JUMP-OP-XCT-NEXT JUMP-ON-PAGE-FAULT-OR-INTERRUPT-PENDING-OR-SEQUENCE-BREAK-CONDITION) CONS-LAP-SYM)

(DEFPROP CALL-IF-SEQUENCE-BREAK (PLUS JUMP-IF-SEQUENCE-BREAK P-BIT) CONS-LAP-SYM)
(DEFPROP CALL-IF-SEQUENCE-BREAK-XCT-NEXT
         (PLUS JUMP-IF-SEQUENCE-BREAK-XCT-NEXT P-BIT) CONS-LAP-SYM)

(DEFPROP POPJ-IF-SEQUENCE-BREAK (PLUS JUMP-IF-SEQUENCE-BREAK R-BIT) CONS-LAP-SYM)
(DEFPROP POPJ-IF-SEQUENCE-BREAK-XCT-NEXT
         (PLUS JUMP-IF-SEQUENCE-BREAK-XCT-NEXT R-BIT) CONS-LAP-SYM)

(DEFPROP WRITE-I-MEM (PLUS JUMP-OP P-BIT R-BIT JUMP-ALWAYS) CONS-LAP-SYM)

(DEFPROP JUMP-CONDITIONAL JUMP-OP CONS-LAP-SYM) ;DEFINED FOR CONVENIENCE
(DEFPROP JUMP-CONDITIONAL-XCT-NEXT JUMP-OP-XCT-NEXT CONS-LAP-SYM) ;LIKEWISE

(DEFPROP CALL-CONDITIONAL (PLUS JUMP-OP P-BIT) CONS-LAP-SYM)    ;DEFINED FOR CONVIENENCE
(DEFPROP CALL-CONDITIONAL-XCT-NEXT (PLUS JUMP-OP-XCT-NEXT P-BIT) CONS-LAP-SYM)

(DEFPROP POPJ-CONDITIONAL (PLUS JUMP-CONDITIONAL R-BIT) CONS-LAP-SYM)
(DEFPROP POPJ-CONDITIONAL-XCT-NEXT (PLUS JUMP-CONDITIONAL-XCT-NEXT R-BIT) CONS-LAP-SYM)


(DEFPROP DISPATCH-CALL-XCT-NEXT (PLUS DISPATCH 0) CONS-LAP-SYM)
                                ;THIS SYM DEFINED FOR CONVIENCE, DISPATCH TABLE MUST
                                ;HAVE THE RIGHT THING TO MAKE THIS HAPPEN.

(DEFPROP DISPATCH-XCT-NEXT (PLUS DISPATCH 0) CONS-LAP-SYM)  ;LIKEWISE
(DEFPROP DISPATCH-CALL (PLUS DISPATCH 0) CONS-LAP-SYM)  ;LIKEWISE
(DEFPROP DISPATCH-POPJ-XCT-NEXT (PLUS DISPATCH 0) CONS-LAP-SYM) ;DITTO

(PUTPROP 'POPJ-AFTER-NEXT 100000000000000 'CONS-LAP-SYM)

(DEFPROP LDB BYTE-INST CONS-LAP-SYM)
(DEFPROP DPB (PLUS BYTE-INST MR-BIT) CONS-LAP-SYM)      ;(LIKE PDP10 DPB)SR-BIT REVERSED
(DEFPROP SELECTIVE-DEPOSIT (PLUS (PLUS BYTE-INST        ;(LIKE PDP1 DIP, DAP)
                          MR-BIT) SR-BIT) CONS-LAP-SYM) ;SR-BIT REVERSED

(DEFPROP NO-OP ALU-INST CONS-LAP-SYM)

(DEFPROP SETZ  (FIELD ALU-OP 00) CONS-LAP-SYM)
(DEFPROP AND   (FIELD ALU-OP 01) CONS-LAP-SYM)
(DEFPROP ANDCA (FIELD ALU-OP 02) CONS-LAP-SYM)
(DEFPROP SETM  (FIELD ALU-OP 03) CONS-LAP-SYM)
(DEFPROP ANDCM (FIELD ALU-OP 04) CONS-LAP-SYM)
(DEFPROP SETA  (FIELD ALU-OP 05) CONS-LAP-SYM)
(DEFPROP XOR   (FIELD ALU-OP 06) CONS-LAP-SYM)
(DEFPROP IOR   (FIELD ALU-OP 07) CONS-LAP-SYM)
(DEFPROP ANDCB (FIELD ALU-OP 10) CONS-LAP-SYM)
(DEFPROP EQV   (FIELD ALU-OP 11) CONS-LAP-SYM)
(DEFPROP SETCA (FIELD ALU-OP 12) CONS-LAP-SYM)
(DEFPROP ORCA  (FIELD ALU-OP 13) CONS-LAP-SYM)
(DEFPROP SETCM (FIELD ALU-OP 14) CONS-LAP-SYM)
(DEFPROP ORCM  (FIELD ALU-OP 15) CONS-LAP-SYM)
(DEFPROP ORCB  (FIELD ALU-OP 16) CONS-LAP-SYM)
(DEFPROP SETO  (FIELD ALU-OP 17) CONS-LAP-SYM)

(DEFPROP ADD   (FIELD ALU-OP 31) CONS-LAP-SYM)
(DEFPROP SUB   (PLUS (FIELD ALU-OP 26) ALU-CARRY-IN-ONE) CONS-LAP-SYM)
(DEFPROP SUB-M+1 (FIELD ALU-OP 26) CONS-LAP-SYM)
(DEFPROP M+M   (FIELD ALU-OP 37) CONS-LAP-SYM)
(DEFPROP M+1   (PLUS (FIELD ALU-OP 34) ALU-CARRY-IN-ONE) CONS-LAP-SYM)
(DEFPROP M-A-1 (FIELD ALU-OP 26) CONS-LAP-SYM)
(DEFPROP M+A+1 (PLUS (FIELD ALU-OP 31) ALU-CARRY-IN-ONE) CONS-LAP-SYM)
(DEFPROP M+M+1 (PLUS (FIELD ALU-OP 37) ALU-CARRY-IN-ONE) CONS-LAP-SYM)


(DEFPROP MULTIPLY-STEP (PLUS (PLUS (FIELD ALU-OP 40) SHIFT-Q-RIGHT)
                         OUTPUT-SELECTOR-RIGHTSHIFT-1) CONS-LAP-SYM)
(DEFPROP DIVIDE-FIRST-STEP (PLUS (PLUS (FIELD ALU-OP 51) SHIFT-Q-LEFT)
                         OUTPUT-SELECTOR-LEFTSHIFT-1) CONS-LAP-SYM)
(DEFPROP DIVIDE-STEP (PLUS (PLUS (FIELD ALU-OP 41) SHIFT-Q-LEFT)
                         OUTPUT-SELECTOR-LEFTSHIFT-1) CONS-LAP-SYM)
(DEFPROP DIVIDE-LAST-STEP (PLUS (FIELD ALU-OP 41) SHIFT-Q-LEFT) CONS-LAP-SYM)
(DEFPROP DIVIDE-REMAINDER-CORRECTION-STEP (FIELD ALU-OP 45) CONS-LAP-SYM)

; FUNCTION SOURCES
(DEFPROP READ-I-ARG
                (OR (SOURCE-P (FIELD FUNCTION-SOURCE 0))
                    (ERROR)) CONS-LAP-SYM)

(DEFPROP MICRO-STACK-PNTR-AND-DATA
                (OR (SOURCE-P (FIELD FUNCTION-SOURCE 1))
                    (ERROR)) CONS-LAP-SYM)

(DEFPROP PDL-BUFFER-POINTER (OR (SOURCE-P (FIELD FUNCTION-SOURCE 2))
                                (FIELD FUNCTION-DESTINATION 14)) CONS-LAP-SYM)

(DEFPROP PDL-BUFFER-INDEX (OR (SOURCE-P (FIELD FUNCTION-SOURCE 3))
                              (FIELD FUNCTION-DESTINATION 13)) CONS-LAP-SYM)

(DEFPROP C-PDL-BUFFER-INDEX
                (OR (SOURCE-P (FIELD FUNCTION-SOURCE 5))
                    (FIELD FUNCTION-DESTINATION 12)) CONS-LAP-SYM)

(DEFPROP C-OPC-BUFFER (OR (SOURCE-P (FIELD FUNCTION-SOURCE 6))
                          (ERROR)) CONS-LAP-SYM)

(DEFPROP Q-R (OR (SOURCE-P (FIELD FUNCTION-SOURCE 7))
                 (FORCE-ALU 3)) CONS-LAP-SYM)

(DEFPROP MEMORY-MAP-DATA (OR (SOURCE-P (FIELD FUNCTION-SOURCE 11))
                              (ERROR)) CONS-LAP-SYM)

(DEFPROP READ-MEMORY-DATA (OR (SOURCE-P (FIELD FUNCTION-SOURCE 12))
                              (ERROR)) CONS-LAP-SYM)

(DEFPROP LOCATION-COUNTER (OR (SOURCE-P (FIELD FUNCTION-SOURCE 13))
                            (FIELD FUNCTION-DESTINATION 1)) CONS-LAP-SYM)

(DEFPROP MICRO-STACK-PNTR-AND-DATA-POP
                (OR (SOURCE-P (FIELD FUNCTION-SOURCE 14))
                    (ERROR)) CONS-LAP-SYM)

(DEFPROP MICRO-STACK-POINTER (OR (SOURCE-P (PLUS (FIELD FUNCTION-SOURCE 1)
                                                 (BYTE-FIELD 5 24.)))
                                 (ERROR)) CONS-LAP-SYM)

(DEFPROP MICRO-STACK-POINTER-POP (OR (SOURCE-P (PLUS (FIELD FUNCTION-SOURCE 14)
                                                     (BYTE-FIELD 5 24.)))
                                     (ERROR)) CONS-LAP-SYM)

(DEFPROP MICRO-STACK-DATA (OR (SOURCE-P (PLUS (FIELD FUNCTION-SOURCE 1)
                                              (BYTE-FIELD 19. 0)))
                              (ERROR)) CONS-LAP-SYM)

(DEFPROP MICRO-STACK-DATA-POP
                (OR (SOURCE-P (PLUS (FIELD FUNCTION-SOURCE 14)
                                    (BYTE-FIELD 19. 0)))
                    (ERROR)) CONS-LAP-SYM)

(DEFPROP C-PDL-BUFFER-POINTER
                (OR (SOURCE-P (FIELD FUNCTION-SOURCE 25))
                    (FIELD FUNCTION-DESTINATION 10)) CONS-LAP-SYM)

(DEFPROP C-PDL-BUFFER-POINTER-POP
                (OR (SOURCE-P (FIELD FUNCTION-SOURCE 24))
                    (ERROR)) CONS-LAP-SYM)

;FUNCTION-DESTINATIONS

(DEFPROP INTERRUPT-CONTROL (OR (SOURCE-P (ERROR))
                               (FIELD FUNCTION-DESTINATION 2)) CONS-LAP-SYM)

;WRITE-MEMORY-DATA AND MD ARE SYNONYMS.  WRITE-MEMORY-DATA WILL GO
; AWAY EVENTUALLY
(DEFPROP WRITE-MEMORY-DATA
                (OR (SOURCE-P (FIELD FUNCTION-SOURCE 12))
                    (FIELD FUNCTION-DESTINATION 30)) CONS-LAP-SYM)

(DEFPROP MD
                (OR (SOURCE-P (FIELD FUNCTION-SOURCE 12))
                    (FIELD FUNCTION-DESTINATION 30)) CONS-LAP-SYM)

(DEFPROP WRITE-MEMORY-DATA-START-WRITE
                (OR (SOURCE-P (ERROR))
                    (FIELD FUNCTION-DESTINATION 32)) CONS-LAP-SYM)

(DEFPROP MD-START-WRITE
                (OR (SOURCE-P (ERROR))
                    (FIELD FUNCTION-DESTINATION 32)) CONS-LAP-SYM)

(DEFPROP WRITE-MEMORY-DATA-WRITE-MAP
                (OR (SOURCE-P (ERROR))
                    (FIELD FUNCTION-DESTINATION 33)) CONS-LAP-SYM)

(DEFPROP MD-WRITE-MAP
                (OR (SOURCE-P (ERROR))
                    (FIELD FUNCTION-DESTINATION 33)) CONS-LAP-SYM)

(DEFPROP VMA (OR (SOURCE-P (FIELD FUNCTION-SOURCE 10))
                 (FIELD FUNCTION-DESTINATION 20)) CONS-LAP-SYM)

(DEFPROP VMA-START-READ (OR (SOURCE-P (ERROR))
                            (FIELD FUNCTION-DESTINATION 21)) CONS-LAP-SYM)

(DEFPROP VMA-START-WRITE (OR (SOURCE-P (ERROR))
                             (FIELD FUNCTION-DESTINATION 22)) CONS-LAP-SYM)

(DEFPROP VMA-WRITE-MAP  (OR (SOURCE-P (ERROR))
                            (FIELD FUNCTION-DESTINATION 23)) CONS-LAP-SYM)

;10 C-PDL-BUFFER-POINTER

(DEFPROP C-PDL-BUFFER-POINTER-PUSH
                (OR (SOURCE-P (ERROR))
                    (FIELD FUNCTION-DESTINATION 11)) CONS-LAP-SYM)

(DEFPROP MICRO-STACK-DATA-PUSH
                (OR (SOURCE-P (ERROR))
                    (FIELD FUNCTION-DESTINATION 15)) CONS-LAP-SYM)

(DEFPROP OA-REG-LOW (OR (SOURCE-P (ERROR))
                        (FIELD FUNCTION-DESTINATION 16)) CONS-LAP-SYM)

(DEFPROP OA-REG-HIGH (OR (SOURCE-P (ERROR))
                         (FIELD FUNCTION-DESTINATION 17)) CONS-LAP-SYM)
(DEFPROP OA-REG-HI (OR (SOURCE-P (ERROR))
                       (FIELD FUNCTION-DESTINATION 17)) CONS-LAP-SYM)

;New names for some things:  pdl-buffer

(DEFPROP PDL-PUSH
         (OR (SOURCE-P (ERROR))
             (FIELD FUNCTION-DESTINATION 11)) CONS-LAP-SYM)

(DEFPROP PDL-POP
         (OR (SOURCE-P (FIELD FUNCTION-SOURCE 24))
             (ERROR)) CONS-LAP-SYM)

(DEFPROP PDL-POINTER
         (OR (SOURCE-P (FIELD FUNCTION-SOURCE 2))
             (FIELD FUNCTION-DESTINATION 14)) CONS-LAP-SYM)

(DEFPROP PDL-INDEX
         (OR (SOURCE-P (FIELD FUNCTION-SOURCE 3))
             (FIELD FUNCTION-DESTINATION 13)) CONS-LAP-SYM)

(DEFPROP PDL-TOP
         (OR (SOURCE-P (FIELD FUNCTION-SOURCE 25))
             (FIELD FUNCTION-DESTINATION 10)) CONS-LAP-SYM)

(DEFPROP PDL-POINTER-INDIRECT
         (OR (SOURCE-P (FIELD FUNCTION-SOURCE 25))
             (FIELD FUNCTION-DESTINATION 10)) CONS-LAP-SYM)

(DEFPROP PDL-INDEX-INDIRECT
         (OR (SOURCE-P (FIELD FUNCTION-SOURCE 5))
             (FIELD FUNCTION-DESTINATION 12)) CONS-LAP-SYM)

;Other things

(DEFPROP I-ARG
         (OR (SOURCE-P (FIELD FUNCTION-SOURCE 0))
             (ERROR)) CONS-LAP-SYM)

(DEFPROP MAP-DATA (OR (SOURCE-P (FIELD FUNCTION-SOURCE 11))
                      (ERROR)) CONS-LAP-SYM)

(DEFPROP INSTRUCTION-FETCH (FORCE-DISPATCH 1_24.) CONS-LAP-SYM)
(DEFPROP PUSH-OWN-ADDRESS (FORCE-DISPATCH 1_25.) CONS-LAP-SYM)

(DEFPROP DISPATCH-ON-MAP-18 (FORCE-DISPATCH 1_8) CONS-LAP-SYM)
(DEFPROP DISPATCH-ON-MAP-19 (FORCE-DISPATCH 1_9) CONS-LAP-SYM)

(DEFPROP SHIFT-ALU-RIGHT
        (FIELD ALU-OUTPUT-BUS-SELECTOR-MULTIPLIER 2) CONS-LAP-SYM)
(DEFPROP SHIFT-ALU-LEFT
        (FIELD ALU-OUTPUT-BUS-SELECTOR-MULTIPLIER 3) CONS-LAP-SYM)
