;;; -*- Mode:LISP; Package:USER; Readtable:CL; Base:10 -*-

(defvar *highest-illop-code*        nil)
(defvar *illop-codes*               nil)
(defvar *illop-file-version-number* 0)

(defvar *illop-file* (pathname "K-SYS:K;ILLOP-CODES.LISP"))

(defun get-illop-codes ()
  (let ((file (probef *illop-file*))
        data)
    (with-open-file (illop-codes file :direction :input)
      (setq data (read illop-codes)))
    (setq *highest-illop-code* (car data))
    (setq *illop-codes*        (rest data))
    (setq *illop-file-version-number* (send file :version))
    ))

(defun dump-illop-codes ()
  (let* ((file (probef *illop-file*))
         (the-new-version (1+ (cond ((null file) 0) (t (send file :version))))))
    (with-open-file (illop-codes *illop-file* :direction :output)
      (format illop-codes ";;; -*- Mode:LISP; Package:USER; Base: 10; Readtable:CL -*-")
      (format illop-codes "~%~%;;; Automatically generated.  Do not edit this file.")
      (format illop-codes "~%~%(~s" *highest-illop-code*)
      (dolist (code (si::merge-sort *illop-codes* #'> #'first))
        (format illop-codes "~% (#x~8,'0X . ~S)" (car code) (cdr code)))
      (format illop-codes ")"))
    (setq *illop-file-version-number* the-new-version)
    ))

(defun allocate-illop-code (string)
  (without-interrupts
    (let ((match (rassoc string *illop-codes* :test #'string-equal)))
      (if match
          (first match)
          (prog1 *highest-illop-code*
                 (push (cons *highest-illop-code* string) *illop-codes*)
                 (incf *highest-illop-code*))))))

(defun get-illop-string (code)
  (when (null *illop-codes*)
    (get-illop-codes))
  (cdr (assq code *illop-codes*)))

(eval-when (load)
  (get-illop-codes))

(defun illop-codes-up-to-date? ()
  (let ((file (probef *illop-file*)))
    (cond ((null file) nil)
          (t (= (send file :version) *illop-file-version-number*)))))

(defun load-illop-codes-if-necessary ()
  (when (not (illop-codes-up-to-date?))
    (get-illop-codes)))

(defun keeping-illop-codes-consistent (thunk)
  (load-illop-codes-if-necessary)
  (let ((old-codes *illop-codes*))
    (multiple-value-prog1
      (funcall thunk)
      (when (not (eq old-codes *illop-codes*))
        (if (illop-codes-up-to-date?)
            (dump-illop-codes)
            (progn (format t "~%WARNING: Illop codes not updated.  You should recompile.")
                   (get-illop-codes))
            )))))

