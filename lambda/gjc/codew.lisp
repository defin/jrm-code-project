

;;; This is a flavor definition generated by the window maker.

(DEFFLAVOR
 WINDOW-MAKER:MY-FLAVOR
 NIL
 (TV:BORDERED-CONSTRAINT-FRAME)
 (:DEFAULT-INIT-PLIST
  :PANES
  '((BATCH-JOB-2 TV:WINDOW
                 :BLINKER-DESELECTED-VISIBILITY
                 :ON
                 :BLINKER-FLAVOR
                 TV:RECTANGULAR-BLINKER
                 :BLINKER-P
                 T
                 :DEEXPOSED-TYPEIN-ACTION
                 :NORMAL
                 :DEEXPOSED-TYPEOUT-ACTION
                 :NORMAL
                 :LABEL
                 NIL
                 :SAVE-BITS
                 T)
    (BATCH-JOB-1 TV:WINDOW
                 :BLINKER-DESELECTED-VISIBILITY
                 :ON
                 :BLINKER-FLAVOR
                 TV:RECTANGULAR-BLINKER
                 :BLINKER-P
                 T
                 :DEEXPOSED-TYPEIN-ACTION
                 :NORMAL
                 :DEEXPOSED-TYPEOUT-ACTION
                 :NORMAL
                 :LABEL
                 NIL
                 :SAVE-BITS
                 T)
    (BATCH-CONTROL TV:WINDOW
                   :BLINKER-DESELECTED-VISIBILITY
                   :ON
                   :BLINKER-FLAVOR
                   TV:RECTANGULAR-BLINKER
                   :BLINKER-P
                   T
                   :DEEXPOSED-TYPEIN-ACTION
                   :NORMAL
                   :DEEXPOSED-TYPEOUT-ACTION
                   :PERMIT
                   :LABEL
                   NIL
                   :SAVE-BITS
                   T)
    (BATCH-JOB-5 TV:WINDOW
                 :BLINKER-DESELECTED-VISIBILITY
                 :ON
                 :BLINKER-FLAVOR
                 TV:RECTANGULAR-BLINKER
                 :BLINKER-P
                 T
                 :DEEXPOSED-TYPEIN-ACTION
                 :NORMAL
                 :DEEXPOSED-TYPEOUT-ACTION
                 :NORMAL
                 :LABEL
                 NIL
                 :SAVE-BITS
                 T)
    (BATCH-JOB-4 TV:WINDOW
                 :BLINKER-DESELECTED-VISIBILITY
                 :ON
                 :BLINKER-FLAVOR
                 TV:RECTANGULAR-BLINKER
                 :BLINKER-P
                 T
                 :DEEXPOSED-TYPEIN-ACTION
                 :NORMAL
                 :DEEXPOSED-TYPEOUT-ACTION
                 :NORMAL
                 :LABEL
                 NIL
                 :SAVE-BITS
                 T)
    (BATCH-JOB-3 TV:WINDOW
                 :BLINKER-DESELECTED-VISIBILITY
                 :ON
                 :BLINKER-FLAVOR
                 TV:RECTANGULAR-BLINKER
                 :BLINKER-P
                 T
                 :DEEXPOSED-TYPEIN-ACTION
                 :NORMAL
                 :DEEXPOSED-TYPEOUT-ACTION
                 :NORMAL
                 :LABEL
                 NIL
                 :SAVE-BITS
                 T))
  :CONSTRAINTS
  (QUOTE
   ((NIL
     (WINDOW-MAKER:WHOLE)
     ((WINDOW-MAKER:WHOLE
       :HORIZONTAL
       (:EVEN)
       (DUMMY-NAME5 DUMMY-NAME6)
       ((DUMMY-NAME5 :VERTICAL
                     (:EVEN)
                     (BATCH-CONTROL BATCH-JOB-1 BATCH-JOB-2)
                     ((BATCH-CONTROL 0.335766s0) (BATCH-JOB-1 0.335766s0))
                     ((BATCH-JOB-2 :EVEN)))
        (DUMMY-NAME6 :VERTICAL
                     (:EVEN)
                     (BATCH-JOB-3 BATCH-JOB-4 BATCH-JOB-5)
                     ((BATCH-JOB-3 0.331387s0) (BATCH-JOB-4 0.337227s0))
                     ((BATCH-JOB-5 :EVEN))))))))))
 :GETTABLE-INSTANCE-VARIABLES
 :SETTABLE-INSTANCE-VARIABLES
 :INITTABLE-INSTANCE-VARIABLES)


(DEFMETHOD (WINDOW-MAKER:MY-FLAVOR :AFTER :INIT) (&REST IGNORE)
  (FUNCALL-SELF :SET-SELECTION-SUBSTITUTE (FUNCALL-SELF :GET-PANE 'BATCH-CONTROL)))
