;;; -*- Mode:LISP; Package:K-KBUG; Compile-In-Roots:(K-GLOBAL); Base:10; Readtable:CL -*-


(defun window-kbug2 (&optional starting-address)
  (let ((*package* (find-package "K-KBUG")))
    (when starting-address
      (kbug-write-pc starting-address))
    (when (not (kbug-stopped?))
      (k-mem-write (ash k2:kbug-status-addr 2) k2:kbug-status-busy)
      (k-mem-write (ash k2:kbug-command-addr 2) k2:kbug-command-continue)
      (format t "~%K is running - waiting for it to stop~%")
      (kbug-wait-until-stopped))
    (deinstall-breakpoints)
    (do ()
        (nil)
      (let* ((addr (logand #xFFFFFF (kbug-read-pc)))
             (sym-addr (get-warm-symbolic-address addr)))
        (if sym-addr
            (format t "~&~30a  " (get-warm-symbolic-address addr))
          (format t "~&~6,'0x               " addr))
        (kbug2-print-instruction (kbug-read-inst addr) addr))
      (USER#:update-regs)
      (catch 'kbug-cmd-error
        (let ((input (peek-char)))
          (kbug-stop)
          (case input
            ((#\space #\c-n)
             (read-char)
             (kbug-step 1 nil)
             (USER#:update-regs)
             )
            ((#\c-p ) (read-char)
                      (kbug-proceed)
                      (kbug-wait-until-stopped-and-no-pause)
                      (deinstall-breakpoints)
                      (USER#:show-call-stack))
            (#\c-f (read-char)
                   (USER#:update-regs))
            ((#\c-z ) (read-char) (kbug-stop))
  ;         (#\q (read-char) (return-from kbug2))
            ((#\c-l #\clear-screen)
             (read-char)
             (zl::send *terminal-io* :clear-window))
            (#\m-f (read-char)
                   (kbug2-flush-call-stack)
                   (USER#:show-call-stack)
                   (USER#:update-regs)
                   )
            (#\m-r (read-char)
                   ;; run rep
                   )
            (#\m-l (read-char)
                   ;; run listerner
                   )
            (#\m-s (read-char)
                   (USER#:show-call-stack))
            (#\m-e (read-char) (format t "~%") (show-error))
            (#\help (read-char) (debugger-help))
            (otherwise
             (zl:catch-error-restart ((sys:abort) "Return to KBUG2.")
               (multiple-value-bind (sexp flag)
                   (zl:with-input-editing (*terminal-io* '((:full-rubout :full-rubout)
                                                           (:activation char= #\end)
                                                           (:prompt prompt-for-kbug)))
                     (read))
                 (if (eq flag :full-rubout)
                     ()
                   (progn
                     (terpri)
                     (prin1 (prog1 (eval sexp) (terpri)))
                     (USER#:update-regs))))))))))))

(defun read-user-frame ()
  (kbug-cmd-confirm k2:kbug-command-read-call-stack)
  (list (kbug-data #xd) (kbug-data #xe))
  )

(defun read-call-stack-entry (depth)
  (kbug-wait-until-stopped)
  (kbug-cmd-confirm k2:kbug-command-read-call-stack)
  (if (or (zerop depth)
          (minusp depth)
          (< (logand #xff (kbug-data 0)) depth))
      (error "Call stack depth, ~d, is less than ~D " (logand #xff (kbug-data 0)) depth))
  (let* ((d0 (kbug-data (1+ (* 2 (1- depth)))))
         (d1 (kbug-data (+ 2 (* 2 (1- depth)))))
         (rpc (ldb (byte 24. 0.) d0))
         (rdf (ldb (byte 3. 28.) d0))
         (rdr (ldb (byte 4. 24.) d0))
         (o   (ldb (byte 8. 8.) d1))
         (a   (ldb (byte 8. 0.) d1))
         (sym-adr (kbug-symbolic-address rpc)))
;    (format t "~%  Ret-Dest ~[ O~; A~; R~; G~;NO~;NO~;NT~;NT~]~2,'0D   Open ~2,'0X   Active ~2,'0X   rpc ~6,'0X"
;           rdf rdr o a rpc)
;    (when sym-adr (format t " ~a" sym-adr))
    (values sym-adr rpc rdf rdr o a)
    )
  )
