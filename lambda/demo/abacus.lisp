;;;-*- Mode:LISP; Package:HACKS; Base:8; Readtable:ZL -*-

(DEFFLAVOR ABACUS-WINDOW
        ((NBEADS 10.)
         (BEAD-MARGIN-WIDTH 4.)
         (RACK-WIDTH 8.)
         (CURRENT-NUMBER 0)
         DISPLAYED-NUMBER
         RACK-LEFT
         UPPER-RACK-TOP
         LOWER-RACK-TOP
         )
        (TV:WINDOW)
  (:DEFAULT-INIT-PLIST :FONT-MAP '(FONTS:ABACUS) :BLINKER-P NIL :MORE-P NIL)
  (:INITABLE-INSTANCE-VARIABLES NBEADS BEAD-MARGIN-WIDTH RACK-WIDTH CURRENT-NUMBER)
  (:GETTABLE-INSTANCE-VARIABLES CURRENT-NUMBER))

(DEFMETHOD (ABACUS-WINDOW :AFTER :REFRESH) (&OPTIONAL IGNORE)
  (OR TV:RESTORED-BITS-P
      (LET ((INSIDE-LEFT (TV:SHEET-INSIDE-LEFT))
            (INSIDE-TOP (TV:SHEET-INSIDE-TOP))
            (INSIDE-RIGHT (TV:SHEET-INSIDE-RIGHT))
            (INSIDE-BOTTOM (TV:SHEET-INSIDE-BOTTOM))
            (BEAD-WIDTH (FONT-CHAR-WIDTH TV:CURRENT-FONT))
            (BEAD-HEIGHT (FONT-CHAR-HEIGHT TV:CURRENT-FONT)))
        (LET ((INSIDE-WIDTH (- INSIDE-RIGHT INSIDE-LEFT))
              (MAGIC-WIDTH (+ (* NBEADS BEAD-WIDTH)
                              (* (1+ NBEADS) BEAD-MARGIN-WIDTH)
                              (* 2 RACK-WIDTH)))
              (MAGIC-HEIGHT (+ (* BEAD-HEIGHT (+ 2 5))
                               (* 3 RACK-WIDTH)
                               4))
              (MAGIC-MIDDLE-Y (+ (* BEAD-HEIGHT 2)
                                 (* 2 RACK-WIDTH)
                                 2))
              RECT-LEFT RECT-TOP RECT-RIGHT RECT-BOTTOM)
          (SETQ RECT-LEFT (TRUNCATE (- INSIDE-WIDTH MAGIC-WIDTH) 2))
          (OR (PLUSP RECT-LEFT) (FERROR "Window not wide enough"))
          (SETQ RECT-TOP (+ INSIDE-TOP RECT-LEFT)
                RECT-LEFT (+ INSIDE-LEFT RECT-LEFT))
          (SETQ RECT-RIGHT (+ RECT-LEFT MAGIC-WIDTH))
          (SETQ RECT-BOTTOM (+ RECT-TOP MAGIC-HEIGHT))
          (OR (< RECT-BOTTOM INSIDE-BOTTOM)
              (FERROR "Window not high enough"))
          (SEND SELF :DRAW-HOLLOW-RECTANGLE RECT-LEFT RECT-TOP RECT-RIGHT RECT-BOTTOM)
          (SEND SELF :DRAW-HOLLOW-RECTANGLE (+ RECT-LEFT RACK-WIDTH)
                                            (+ RECT-TOP RACK-WIDTH)
                                            (- RECT-RIGHT RACK-WIDTH)
                                            (- (+ RECT-TOP MAGIC-MIDDLE-Y) RACK-WIDTH))
          (SEND SELF :DRAW-HOLLOW-RECTANGLE (+ RECT-LEFT RACK-WIDTH)
                                            (+ RECT-TOP MAGIC-MIDDLE-Y)
                                            (- RECT-RIGHT RACK-WIDTH)
                                            (- RECT-BOTTOM RACK-WIDTH))
          (SETQ RACK-LEFT (+ RECT-LEFT RACK-WIDTH 1)
                UPPER-RACK-TOP (+ RECT-TOP RACK-WIDTH 1))
          (SETQ LOWER-RACK-TOP (+ RECT-TOP MAGIC-MIDDLE-Y 1))
          (SETQ DISPLAYED-NUMBER NIL)
          (SEND SELF :REDISPLAY)))))

(DEFMETHOD (ABACUS-WINDOW :DRAW-HOLLOW-RECTANGLE) (LEFT TOP RIGHT BOTTOM)
  (TV:PREPARE-SHEET (SELF)
    (SYS:%DRAW-LINE LEFT TOP RIGHT TOP TV:CHAR-ALUF NIL SELF)
    (SYS:%DRAW-LINE (1- RIGHT) TOP (1- RIGHT) BOTTOM TV:CHAR-ALUF NIL SELF)
    (SYS:%DRAW-LINE (1- RIGHT) (1- BOTTOM) LEFT (1- BOTTOM) TV:CHAR-ALUF NIL SELF)
    (SYS:%DRAW-LINE LEFT TOP LEFT BOTTOM TV:CHAR-ALUF NIL SELF)))

(DEFMETHOD (ABACUS-WINDOW :REDISPLAY) (&AUX BEAD-WIDTH)
  (SETQ BEAD-WIDTH (+ BEAD-MARGIN-WIDTH (FONT-CHAR-WIDTH TV:CURRENT-FONT)))
  (DO ((I 0 (1+ I))
       (X (+ RACK-LEFT BEAD-MARGIN-WIDTH (* (1- NBEADS) BEAD-WIDTH)) (- X BEAD-WIDTH))
       (N CURRENT-NUMBER (TRUNCATE N 10.))
       (M DISPLAYED-NUMBER (AND M (TRUNCATE M 10.))))
      (( I NBEADS))
    (SEND SELF :DRAW-BEADS
               X UPPER-RACK-TOP 2 (LOGXOR (TRUNCATE (\ N 10.) 5) 1)
               (AND M (LOGXOR (TRUNCATE (\ M 10.) 5) 1)))
    (SEND SELF :DRAW-BEADS X LOWER-RACK-TOP 5 (\  N 5) (AND M (\ M 5))))
  (SETQ DISPLAYED-NUMBER CURRENT-NUMBER))

(DEFMETHOD (ABACUS-WINDOW :DRAW-BEADS) (X Y NHIGH VAL OVAL)
  (OR (EQ VAL OVAL)
      (TV:PREPARE-SHEET (SELF)
        (LET* ((BEAD-WIDTH (FONT-CHAR-WIDTH TV:CURRENT-FONT))
               (BEAD-HEIGHT (FONT-CHAR-HEIGHT TV:CURRENT-FONT))
               (LEN (LSH 1 NHIGH))
               (ALLBITS (1- LEN))
               (BITS (LOGXOR ALLBITS (LSH LEN (- (1+ VAL)))))
               (OBITS (IF OVAL
                          (LOGXOR ALLBITS (LSH LEN (- (1+ OVAL))))
                          (LOGXOR BITS ALLBITS))))
          (DO ((I 0 (1+ I))
               (Y1 Y (+ Y1 BEAD-HEIGHT))
               (MASK (LOGXOR BITS OBITS))
               (PPSS (DPB (1- NHIGH) 0606 0001) (- PPSS 0100)))
              (( I NHIGH))
            (AND (LDB-TEST PPSS MASK)
                 (LET ((CHAR (IF (LDB-TEST PPSS BITS) #/B #/A)))
                   (SYS:%DRAW-RECTANGLE BEAD-WIDTH BEAD-HEIGHT X Y1 TV:ERASE-ALUF SELF)
                   (TV#:DRAW-CHAR TV:CURRENT-FONT CHAR X Y1 TV:CHAR-ALUF SELF))))))))

(DEFMETHOD (ABACUS-WINDOW :SET-CURRENT-NUMBER) (NEW-NUMBER)
  (LET ((MAX (^ 10. NBEADS)))
    (SETQ NEW-NUMBER (\ NEW-NUMBER MAX))
    (AND (MINUSP NEW-NUMBER)
         (SETQ NEW-NUMBER (+ MAX NEW-NUMBER))))
  (SETQ CURRENT-NUMBER NEW-NUMBER)
  (TV:SHEET-FORCE-ACCESS (SELF)
    (SEND SELF :REDISPLAY)))

(DEFMETHOD (ABACUS-WINDOW :MOUSE-CLICK) (BUTTON X Y &AUX TEM)
  (WHEN (= BUTTON #\MOUSE-1-1)
    (IF (SETQ TEM (SEND SELF :BEAD-CLICK X Y))
        (PROCESS-RUN-FUNCTION "Click" (LAMBDA (S N) (SEND S :SET-CURRENT-NUMBER N)) SELF TEM)
      (BEEP))
    T))

(DEFMETHOD (ABACUS-WINDOW :BEAD-CLICK) (X Y &AUX BEAD-WIDTH BEAD-HEIGHT)
  (SETQ BEAD-WIDTH (FONT-CHAR-WIDTH TV:CURRENT-FONT)
        BEAD-HEIGHT (FONT-CHAR-HEIGHT TV:CURRENT-FONT))
  (LET ((XIDX (TRUNCATE (- X (+ RACK-LEFT BEAD-MARGIN-WIDTH)) (+ BEAD-WIDTH BEAD-MARGIN-WIDTH))))
    (AND ( XIDX 0) (< XIDX NBEADS)
         (< X (+ RACK-LEFT BEAD-MARGIN-WIDTH (* XIDX (+ BEAD-WIDTH BEAD-MARGIN-WIDTH))
                 BEAD-WIDTH))
         (LET* ((TOP-P (< Y LOWER-RACK-TOP))
                (YIDX (TRUNCATE (- Y (IF TOP-P UPPER-RACK-TOP LOWER-RACK-TOP)) BEAD-HEIGHT)))
           (AND ( YIDX 0) (< YIDX (IF TOP-P 2 5))
                (LET* ((POWER (^ 10. (- NBEADS XIDX 1)))
                       (DIGIT (\ (TRUNCATE CURRENT-NUMBER POWER) 10.))
                       (NDIGIT (IF TOP-P
                                   (+ (\ DIGIT 5) (* 5 (LOGXOR YIDX 1)))
                                   (+ (* 5 (TRUNCATE DIGIT 5)) YIDX))))
                  (AND ( DIGIT NDIGIT)
                       (+ (- CURRENT-NUMBER (* POWER DIGIT)) (* POWER NDIGIT)))))))))

(DEFMETHOD (ABACUS-WINDOW :OPERATE) (OPERATION NUMBER &OPTIONAL (SLEEP-TIME 30.))
  (OR (MEMQ OPERATION '(- +))
      (FERROR "~S is not a known operation" OPERATION))
  (DO ((N NUMBER (TRUNCATE N 10.))
       (POWER 1 (* POWER 10.))
       (NEW-NUMBER))
      ((ZEROP N))
    (SETQ NEW-NUMBER (FUNCALL OPERATION CURRENT-NUMBER (* (\ N 10.) POWER)))
    (LET ((MAX (^ 10. NBEADS)))
      (SETQ NEW-NUMBER (\ NEW-NUMBER MAX))
      (AND (MINUSP NEW-NUMBER)
           (SETQ NEW-NUMBER (+ MAX NEW-NUMBER))))
    (UNLESS (= NEW-NUMBER CURRENT-NUMBER)
      (DO ((I 0 (1+ I))
           (POWER 1 (* POWER 10.))
           (DIGIT) (NDIGIT))
          (( I NBEADS))
        (SETQ DIGIT (\ (TRUNCATE CURRENT-NUMBER POWER) 10.)
              NDIGIT (\ (TRUNCATE NEW-NUMBER POWER) 10.))
        (UNLESS (= DIGIT NDIGIT)
          (SEND SELF :SET-CURRENT-NUMBER
                     (+ (- CURRENT-NUMBER (* POWER DIGIT)) (* POWER NDIGIT)))
          (AND SLEEP-TIME (PROCESS-SLEEP SLEEP-TIME))))))
  CURRENT-NUMBER)

(DEFFLAVOR ABACUS-FRAME () (TV:FRAME-DONT-SELECT-INFERIORS-WITH-MOUSE-MIXIN
                            TV:BORDERED-CONSTRAINT-FRAME TV:PROCESS-MIXIN))

(DEFMETHOD (ABACUS-FRAME :NAME-FOR-SELECTION) () TV:NAME)

(DEFCONST ABACUS-LABEL
          "[END]: exit   =: print   +: add   -: subtract   digits: set number")

(DEFMETHOD (ABACUS-FRAME :BEFORE :INIT) (IGNORE)
  (SETQ TV:PROCESS '(ABACUS-PROCESS-TOP-LEVEL :SPECIAL-PDL-SIZE 4000)
        TV:PANES `((LISP-WINDOW TV:INTERACTION-PANE :LABEL NIL :MORE-P NIL)
                   (ABACUS-WINDOW ABACUS-WINDOW :LABEL ,ABACUS-LABEL))
        TV:CONSTRAINTS '((MAIN . ((ABACUS-WINDOW LISP-WINDOW)
                                  ((LISP-WINDOW 0.25s0 :LINES))
                                  ((ABACUS-WINDOW :EVEN)))))))

(DEFMETHOD (ABACUS-FRAME :AFTER :INIT) (IGNORE)
  (SEND SELF :SELECT-PANE (SEND SELF :GET-PANE 'LISP-WINDOW)))

(DEFUN ABACUS-PROCESS-TOP-LEVEL (WINDOW)
  (DO* ((*TERMINAL-IO* (SEND WINDOW :GET-PANE 'LISP-WINDOW))
        (*STANDARD-OUTPUT* *TERMINAL-IO*)
        (ABACUS-WINDOW (SEND WINDOW :GET-PANE 'ABACUS-WINDOW))
        (*READ-BASE* 10.) (*PRINT-BASE* 10.)
        (CH))
       (NIL)
    (SEND ABACUS-WINDOW :SET-LABEL ABACUS-LABEL)
    (CATCH-ERROR-RESTART ((SYS:ABORT EH:DEBUGGER-CONDITION) "Return to ABACUS command level.")
      (PROGN
        (CASE (SETQ CH (SEND *STANDARD-INPUT* :READ-CHAR))
          (#/=
           (FORMAT T "= ~D~%" (SEND ABACUS-WINDOW :CURRENT-NUMBER)))
          ((#/+ #/-)
           (SEND ABACUS-WINDOW :SET-LABEL
                 (FORMAT NIL "Type a number to ~:[add~;subtract~].  End with Space or Return."
                         (EQ CH #/-)))
           (WRITE-CHAR CH)
           (LET ((NUMBER (READ)))
             (AND (NUMBERP NUMBER)
                  (SEND ABACUS-WINDOW :OPERATE (IF (EQ CH #/+) '+ '-) NUMBER))))
          (#/END
           (SEND WINDOW :DESELECT))
          (OTHERWISE
           (IF (DIGIT-CHAR-P CH)
               (PROGN (SEND *STANDARD-INPUT* :UNREAD-CHAR CH)
                      (SEND ABACUS-WINDOW :SET-LABEL
                            "Type a number to store in the abacus.  End with Space or Return.")
                      (LET ((NUMBER (READ)))
                        (AND (NUMBERP NUMBER)
                             (SEND ABACUS-WINDOW :SET-CURRENT-NUMBER NUMBER))))
             (TV:BEEP))))))))

(DEFVAR *ABACUS-FRAME*)

(DEFUN ABACUS ()
  (OR (BOUNDP '*ABACUS-FRAME*)
      (SETQ *ABACUS-FRAME* (MAKE-INSTANCE 'ABACUS-FRAME :EDGES '(64. 64. 640. 450.))))
  (SEND *ABACUS-FRAME* :SELECT))

(DEFUN ABACUS-DEMO ()
  (ABACUS)
  (PROCESS-WAIT "Deexpose" (LAMBDA (X) (NULL (CONTENTS X)))
                           (LOCF (TV:SHEET-EXPOSED-P *ABACUS-FRAME*))))

(COMPILE-FLAVOR-METHODS ABACUS-WINDOW ABACUS-FRAME)

(DEFDEMO "Abacus" "Upward compatibilty with primitive computers." (ABACUS-DEMO))