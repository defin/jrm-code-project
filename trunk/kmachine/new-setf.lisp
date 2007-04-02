;;; -*- Mode:LISP; Package:SETF; Base:10; Readtable:CL -*-
;;;
;;; SETF.LISP
;;;
;;; Depends on:
;;;    USER::PARSE-LAMBDA-LIST (in LAMBDA-LIST.LISP)

;;; WKF:  Is above correct? LAMBDA-LIST is in package LISP-INTERNALS, LI: version now overwrites USER: version

;;;
;;; Contains:
;;;    - Macros to obtain SETF methods (GET-SETF-METHOD, GET-SETF-METHOD-MULTIPLE-VALUE)
;;;    - Macros to define new SETF methods (DEFSETF, DEFINE-SETF-METHOD, DEFINE-SIMPLE-SETF-METHOD)
;;;    - SETF macro
;;;    - DEFINE-MODIFY-MACRO macro, to define macros that manipulate generalized variables

;;; Note: The actual setf methods have been moved to the file "NEW-SETF-MACROS"
;;;       Don't add setf methods here.
;;;       Also, avoid using setf type things in this file, it is a little confusing
;;;       to deal with.  (I guess it is okay, but there may be a boojum hidden
;;;       here somewhere).

;;; Bugs:
;;;    Simple form of DEFSETF loses the documentation string.

;(export '(setf
;         defsetf
;          define-setf-method
;         get-setf-method
;         get-setf-method-multiple-value
;         define-modify-macro
;         incf decf push pop)
;       'nlisp)

(export '(define-modify-macro
          define-setf-method
          defsetf
          get-setf-method
          get-setf-method-multiple-value
          setf))

(defvar *simple-setf-macro-table* NIL
  "Trivially substituted setf patterns.")

(defvar *grody-setf-macro-table*  NIL
  "An association list matching symbols to lambda expressions.
A table entry matching a symbol FOO to an expression (LAMBDA (args) . body)
means that the SETF method for (FOO . foo-args) may be obtained by applying
the lambda expression to foo-args.  The args list may contain &optional and
&rest arguments.")


;;; GET-SETF-METHOD and GET-SETF-METHOD-MULTIPLE-VALUE
;;;

(defun get-setf-method-multiple-value (form)
  "Return the canonical five values that say how to do SETF on FORM.
The values are:
* a list of symbols, gensyms, that stand for parts of FORM
* a list of the parts of FORM that they stand for
* a list of symbols, gensyms, that stand for the values to be stored
* an expression to do the storing.  It contains the gensyms described already.
* an expression to refer to the existing value of FORM.
  It differs from FORM in that it has the gensyms replacing the
  parts of FORM that they stand for.
These values give all the information needed to examine and set
 FORM repeatedly without evaluating any of its subforms more than once."
  (get-setf-method-multiple-value-internal
    form
    #'values
    #'(lambda ()
        (error "No SETF method is defined for ~S." form))))

(defun get-setf-method-multiple-value-internal (form if-found if-not-found)

  (let ((junk-symbol (gentemp)))
    (cond
      ((symbolp form)
       (funcall if-found
                NIL
                NIL
                (list junk-symbol)
                `(SETQ ,form ,junk-symbol)
                form))
      ((not (consp form))
       (error "Trying to SETF ~S?  Surely you jest!" form))
      ;; I'm not, and don't call me Shirley.
      (t
       (let* ((function-name  (car form))
              (function-args  (cdr form))
              (simple-macro   (cdr (assoc function-name *simple-setf-macro-table*)))
              (grody-method   (cdr (assoc function-name *grody-setf-macro-table*)))
              (temporary-vars (mapcar #'(lambda (ignore) (gentemp)) function-args)))
         (cond

           ;; For the simple cases, access functions listed in the *simple-setf-macro-table*,
           ;; the store form can be generated by substituting into a template.  temps are
           ;; generated, blah, blah

           (simple-macro
            (funcall if-found
                     temporary-vars
                    function-args
                    (list junk-symbol)
                    `(PROGN ,(subst junk-symbol :VALUE
                                    (subst-splicing temporary-vars :ARGS simple-macro))
                            ,junk-symbol)
                    (cons function-name temporary-vars)))

           ;; THE

           ((eq function-name 'the)
            (unless (= (length function-args) 2)
              (error "~S should have exactly 2 arguments." form))
            (multiple-value-bind (temps values stores store-form access-form)
                (get-setf-method (second function-args))
              (funcall if-found temps
                      values
                      stores
                      (subst `(THE ,(first function-args) ,(car stores)) (car stores) store-form)
                      `(THE ,(first function-args) ,access-form))))


           ;; The grody-method knows how to compute the five values.

           (grody-method
            (multiple-value-call if-found
                                 (apply grody-method function-args)))

           (t (funcall if-not-found))))))))


(defun get-setf-method (form)
  "Return the canonical five values that say how to do SETF on FORM.
This is identical to GET-SETF-METHOD-MULTIPLE-VALUE, except that it
checks to make sure there is only one store variable."
  (multiple-value-bind (tempvars argforms storevars storeform accessform)
      (get-setf-method-multiple-value form)
    (if (not (= (length storevars) 1))
        (error "Number of store-variables not one, for SETF method of ~S."
                form)
        (values tempvars argforms storevars storeform accessform))))

(defun subst-splicing (new old list)
  (cond ((null list)
         NIL)
        ((atom list)
         (error "can't splice"))
        ((atom (car list))
         (if (eq (car list) old)
             (append new (subst-splicing new old (cdr list)))
             (cons (car list) (subst-splicing new old (cdr list)))))
        (t
         (cons (subst-splicing new old (car list))
               (subst-splicing new old (cdr list))))))


;;; DEFINE-SIMPLE-SETF-METHOD
;;;
;;; This is used internally to define pathologically trivial SETF methods.  It instructs SETF
;;; to expand (SETF (access-fn . args) foo) into TEMPLATE, substituting args for the :ARGS
;;; keyword in TEMPLATE and foo for the :VALUE keyword in TEMPLATE.

(defmacro define-simple-setf-macro (access-fn template)
  `(PROGN (SETQ *SIMPLE-SETF-MACRO-TABLE*
                (CONS '(,access-fn . ,template)
                      (IF (BOUNDP '*SIMPLE-SETF-MACRO-TABLE*)
                          *SIMPLE-SETF-MACRO-TABLE*
                          NIL)))
          (QUOTE ,access-fn)
          ))


;;; DEFINE-SETF-METHOD
;;;
;;; This is the most general way to instruct SETF how to expand (SETF (access-fn . args) foo).
;;; It tells SETF to bind lambda-list to args, then use body to obtain the five SETF method
;;; values.

(defmacro define-setf-method (access-fn lambda-list &body body)
  `(EVAL-WHEN (COMPILE LOAD EVAL)
     (SETQ *GRODY-SETF-MACRO-TABLE*
           (CONS '(,access-fn . (LAMBDA ,lambda-list . ,body))
                 (IF (BOUNDP '*GRODY-SETF-MACRO-TABLE*)
                     *GRODY-SETF-MACRO-TABLE*
                     NIL)))
     (QUOTE ,access-fn)
     ))


;;; DEFSETF
;;;
;;; There are two forms of DEFSETF.  Both forms add a new SETF method to one of the SETF
;;; macro tables.
;;;
;;; The simple form is (DEFSETF access-function update-function [doc-string]).
;;; This instructs SETF to expand (SETF (access-function arg1 arg2 ...) foo) into
;;; (update-function arg1 arg2 ... foo))
;;;
;;; The complex form is (DEFSETF access-function lambda-list newvalue-lambda-list . body)
;;; This instructs (SETF (access-function arg-list) value) to expand into a form which:
;;;     - binds gensyms to value and the elements of arg-list
;;;     - binds lambda-list, which may contain &OPTIONAL and &REST arguments, to the
;;;       gensyms for arg-list
;;;     - binds newvalue-lambda-list, which may only contain one argument, to the gensym
;;;       for value
;;;     - contains body within these bindings.
;;;
;;; The complex form defines a new SETF method (using DEFINE-SETF-METHOD).  It constructs
;;; a macro which returns the five SETF method values.  (assumes it's lambda of what?)
;;;
;;; Example: (DEFSETF AREF (ARRAY &REST SUBSCRIPTS) (X)
;;;             `(PROGN (ASET ,X ,ARRAY ,@SUBSCRIPTS) ,X))
;;;
;;; becomes something like:
;;;          (DEFINE-SETF-METHOD AREF (ARRAY &REST SUBSCRIPTS)
;;;             (LET* ((SINGLE-TEMPVARS (MAPCAR #'(LAMBDA (IGNORE) (GENTEMP))) '(ARRAY))
;;;                    (REST-TEMPVARS   (MAPCAR #'(LAMBDA (IGNORE) (GENTEMP))) SUBSCRIPTS)
;;;                    (STOREVAR        (GENSYM))
;;;                    (TEMPVARS        (APPEND SINGLE-TEMPVARS REST-TEMPVARS)))
;;;               (VALUES TEMPVARS
;;;                       (LIST* ARRAY (COPY-LIST SUBSCRIPTS))
;;;                       (LIST STOREVAR)
;;;                       (LET ((X STOREVAR)
;;;                             (ARRAY (NTH 0 TEMPVARS))
;;;                             (SUBSCRIPTS REST-TEMPVARS))
;;;                         `(PROGN (ASET ,X ,ARRAY ,@SUBSCRIPTS) ,X)))
;;;                       `(AREF ,@TEMPVARS))))

(defmacro defsetf (&environment environment access-function &optional arg1 arg2 &body body)
  (declare (ignore environment))
  (if (null body)
      (let ((args  (gentemp 'ARGS))
            (value (gentemp 'VALUE)))
        `(DEFSETF ,access-function (&REST ,args) (,value)
           `(,',arg1 ,@,args ,,value)))
      (let ((expansion (expand-2-list-defsetf access-function arg1 arg2 body)))
        `(DEFINE-SETF-METHOD ,access-function ,arg1 ,expansion))))

(eval-when (eval compile load)

(defun expand-2-list-defsetf (access-function access-ll value-names body)
  (macrolet ((mini-incf (variable)
               `(SETQ ,variable (1+ ,variable))))
  (multiple-value-bind (single-arg-names rest-arg)
      (narf-required-optional-and-rest-args access-ll)
    `(LET* ((SINGLE-TEMPVARS (MAPCAR #'(LAMBDA (IGNORE) (GENTEMP)) ',single-arg-names))
            ,@(when rest-arg
                `((REST-TEMPVARS (MAPCAR #'(LAMBDA (IGNORE) (GENTEMP)) ,rest-arg))))
            (STOREVAR (GENSYM))
            (TEMPVARS ,(if rest-arg ; list of temporaries
                           '(APPEND SINGLE-TEMPVARS REST-TEMPVARS)
                           'SINGLE-TEMPVARS)))

       (VALUES
         ;; Gensyms bound to the elements of access-ll
         TEMPVARS

         ;; List of forms that correspond to the temporaries
         ,(if rest-arg
              `(APPEND (LIST ,@single-arg-names) (COPY-LIST ,rest-arg))
              `(LIST  ,@single-arg-names))

         ;; Store variable
         (LIST STOREVAR)

         ;; Store form
         ;; We put the body inside a let where the values of the parameters
         ;; of the lambda list aren't the actual forms, but the gensyms instead
         ;; (and actually, the rest arg is a LIST of gensyms).
         ;; Construct a LET form which binds the actual forms to the gensyms,
         ;; and contains the body of the DEFSETF form.  The store variable,
         ;; the single-argument parameters, and the rest argument parameter
         ;; all must be rebound.
         ,(let* ((foo 0)
                 (storevar-binding `(,(car value-names) STOREVAR))
                 (single-bindings  (mapcar #'(lambda (arg)
                                               (prog1 `(,arg (NTH ,foo TEMPVARS)) (mini-incf foo)))
                                           single-arg-names))
                 (rest-arg-binding (if rest-arg `((,rest-arg REST-TEMPVARS)) NIL)))
            `(LET (,storevar-binding
                   ,@single-bindings
                   ,@rest-arg-binding)
               ,@body))

         ;; Access form
         `(,',access-function . ,tempvars))))))



(defun narf-required-optional-and-rest-args (lambda-list)
  "Return two values: a list of required and optional arguments,
and the rest argument (or NIL if there is none).  For example,
if lambda-list = (a b &optional c (d e) (f g h) &rest i), then
value 1 = (a b c d f)
value 2 = i"
  (multiple-value-bind (required-args optional-args rest-arg)
      (parse-lambda-list lambda-list '(:REQUIRED :OPTIONAL :REST))
    (values (append required-args
                    (mapcar #'(lambda (element)
                                (etypecase element
                                  (symbol element)
                                  (cons   (car element))))
                            optional-args))
            rest-arg)))

)

;;; SETF
;;;

(defmacro setf (&environment environment &body places-and-values)
  (when (oddp (length places-and-values))
    (error "Odd number of arguments to SETF macro."))
  ;; Avoid using SETF before defining setf
  (macrolet ((mini-pop (variable)
               `(PROG1 (CAR ,variable) (SETQ ,variable (CDR ,variable))))
             (mini-push (value variable)
               `(SETQ ,variable (CONS ,value ,variable))))
  (let ((unexpanded-setf-forms places-and-values)
        (expanded-setf-forms   ()))
    (loop
      (if unexpanded-setf-forms
          (mini-push (expand-setf-form (mini-pop unexpanded-setf-forms)
                                       (mini-pop unexpanded-setf-forms)
                                       environment
                                       )
                expanded-setf-forms)
          (return)))
    (case (length places-and-values)
      (0  NIL)
      (2  (first expanded-setf-forms))
      (t  `(PROGN ,@(reverse expanded-setf-forms)))))))

(defun expand-setf-form (place new-value environment)
  (get-setf-method-multiple-value-internal place
    #'(lambda (temporary-variables value-forms store-variables store-form access-form)
        (declare (ignore access-form))
        `(LET* (,@(mapcar #'list temporary-variables value-forms)
                (,(car store-variables) ,new-value))
           ,store-form))
    #'(lambda () (multiple-value-bind (new-form expanded?)
                     (nlisp::macroexpand-1 place environment)
                   (if expanded?
                       (expand-setf-form new-form new-value environment)
                     (let ((ans (global:macroexpand-1 `(global:setf ,place ,new-value))))
                       ;(format t "~%~A,~A->~A" place new-value ans)
                       ans
                       ;(error "Couldn't find a setf method for ~s" place)
                       ))))))


;;; DEFINE-MODIFY-MACRO
;;;
;;; If you think this is bad, remember SUBLIS-EVAL-ONCE-1.

(defmacro define-modify-macro (name lambda-list function &optional doc-string)
  (multiple-value-bind (required-args optional-args rest-arg)
      (parse-lambda-list lambda-list '(:REQUIRED :OPTIONAL :REST))
    (let ((additional-arg-names (append required-args
                                        (mapcar #'(lambda (arg)
                                                    (if (consp arg) (car arg) arg))
                                                optional-args)
                                        (if rest-arg (list rest-arg) NIL)))
          (reference-var (gentemp 'PLACE)))
    `(DEFMACRO ,name (,reference-var ,@lambda-list)
       ,doc-string
       (MULTIPLE-VALUE-BIND (TEMPVARS TEMPARGS STOREVARS STOREFORM ACCESSFORM)
           (GET-SETF-METHOD ,reference-var)
         (LET ((ADDITIONAL-TEMPS (MAPCAR #'(LAMBDA (IGNORE) (GENTEMP)) ',additional-arg-names)))
           `(LET (,@(MAPCAR #'LIST TEMPVARS TEMPARGS)
                  ,@(MAPCAR #'LIST ADDITIONAL-TEMPS (LIST ,@additional-arg-names)))
              (LET ((,(CAR STOREVARS) (,',function ,ACCESSFORM ,@ADDITIONAL-TEMPS)))
                ,STOREFORM))))))))

;;; Here is a way the INCF macro might be defined.  Compare this and the SETF macro given on
;;; page 107 of "Common Lisp" to the DEFMACRO forms generated by DEFINE-MODIFY-MACRO.
;;;
;;; (defmacro incf (place &optional (delta 1))
;;;   (multiple-value-bind (temps values storevars storeform accessform)
;;;       (get-setf-method place)
;;;     (let ((delta-temp (gensym)))
;;;       `(LET (,@(mapcar #'list temps values)
;;;             (,delta-temp ,delta))
;;;          (LET ((,(car storevars) (+ ,accessform ,delta-temp)))
;;;            ,storeform)))))
;;;
;;; It's much easier to define read-modify-write macros using DEFINE-MODIFY-MACRO.  A version
;;; of SETF, which takes exactly two arguments, could be written as:
;;;   (define-modify-macro setf (new-value) (lambda (ignore u) u))
