(do* ((ws warm-symbols (cdr ws)) (sym (car ws) (car ws))) ((null ws))
  (when (member sym (cdr ws)) (format t "~%~s" sym)))

DOCUMENTATION
GENTEMP
EVAL
FUNCTION
MACRO
SPECIAL
BLOCK
TYPE
DEFMACRO
MAPCAR
PROG2
=
GENSYM
SET-CDR
SET-CAR
GET
FIND
ERROR
DPB
NEW-SYMBOL-FUNCTION
PLIST
MAX-NUMBER-OF-SYMBOLS
NUMBER-OF-SYMBOLS
SHADOWING-SYMBOLS
USED-BY-LIST
USE-LIST
NICKNAMES
NAME
REFNAME-ALIST
NUMBER-OF-SLOTS
HASH-TABLE-SYMBOLS
HASH-TABLE-CODES
BOUNDP
NTH
LIST
CONS
REHASH-SIZE
SIZE
TEST-NOT
KEY
FROM-END
COUNT
T
FIXNUM
END
START
TEST
STRING=
CHAR=
LDB
FILL-POINTER
CAAR
CDDR
CADR
ERROR
NAMED-STRUCTURE-INVOKE
BYTE
LDB
REGION-ORIGIN
ASSOCIATE-CLUSTER
FREE-REGION
NAMED-STRUCTURE-SYMBOL
READ-MAP
BOUNDP
MAKE-REGION
NIL


(dribble)
