;;;-*- Mode:LISP; Package:LAMBDA; Base:10; Readtable:ZL -*-
; By Pace Willisson July 1988

(defun dump-conf (quad-slot)
  (let ((adr (- #x01000000 (* 256. 4))))
    (dotimes (i 256.)
      (let ((c (logand (%nubus-read quad-slot (+ adr (* i 4))) #xff)))
        (format t "~c" c)))))

(defun dump-remote-conf (remote-slot)
  (let* ((adr (- #x01000000 (* 256. 4)))
         (mapped-base (+ (mbc-map-slot remote-slot)
                         (if (bit-test 1 remote-slot)
                             1_24.
                           0))))
    (dotimes (i 256.)
      (let ((c (logand (nuread (+ mapped-base adr (* i 4))) #xff)))
        (format t "~c" c)))))

(defun print-mbc-map (&optional (read-func 'read-map))
  (dotimes (map-slot 128.)
    (let ((data (funcall read-func (* map-slot 4))))
      (cond ((and (not (zerop data))
                  (not (ldb-test (byte 1 0) data)))
             (format t "~&map[~3d.] is not valid, but is not 0" map-slot))
            ((ldb-test (byte 1 0) data)
             (format t "~&map[~3d.]: ~8x -> ~8x"
                     map-slot
                     (ash map-slot 25.)
                     (ash (dpb 0 (byte 1 0) data) 24.)))))))

(defun print-remote-mbc-map ()
  (print-mbc-map 'read-remote-map))

(defun alloc-mbc-slot ()
  (do ((map-slot 0 (+ map-slot 1))
       (last-map-slot (ash #xf0000000 -25.)))
      ((= map-slot last-map-slot)
       (ferror nil "couldn't find map slot"))
    (cond ((zerop (read-map (* map-slot 4)))
           (return map-slot)))))

(defun mbc-map-slot (remote-slot)
  (cond ((or (< remote-slot 0)
             (> remote-slot #xf))
         (ferror nil "remote slot must be between 0 and 15.")))
  (let ((map-slot (alloc-mbc-slot)))
    (write-map (* map-slot 4) (logior #xf1 remote-slot))
    (dpb (ldb (byte 1 0) remote-slot) (byte 1 24.) (ash map-slot 25.))))


(defun mbc-map-adr (remote-adr)
  (let ((map-slot (alloc-mbc-slot)))
    (write-map (* map-slot 4) (logior (ash (ldb (byte 7 25.) remote-adr) 1) 1))
    (dpb map-slot (byte 7 25.) (logand remote-adr #x01ffffff))))

(defun nuread (adr)
  (%nubus-read (ldb (byte 8 24.) adr) (ldb (byte 24. 0) adr)))

(defun nuwrite (adr data)
  (%nubus-write (ldb (byte 8 24.) adr) (ldb (byte 24. 0) adr) data))

(defun swap32 (x)
  (logior (ash (ldb (byte 8 0) x) 24.)
          (ash (ldb (byte 8 8) x) 16.)
          (ash (ldb (byte 8 16.) x) 8)
          (ldb (byte 8 24.) x)))

(defun getbuf ()
  (let ((buf (make-array 1024.)))
    (dotimes (i 1024)
      (aset (swap32 (%nubus-read #xfb (* i 4))) buf i))
    buf))

(defun pa (a)
  (dotimes (i (array-length a))
    (format t "(~d ~d) " i (aref a i))))


(defun check-a (a)
  (let ((start (aref a 0)))
    (dotimes (i (array-length a))
      (cond ((not (= (aref a i) (+ i start)))
             (format t "~&error ~d expected #x~x got #x~x" i (+ i start) (aref a i)))))))

(defun macread32 (adr)
  (swap32 (%nubus-read (ldb (byte 8 24.) adr) (ldb (byte 24. 0) adr))))

(defun nuread32 (adr)
  (%nubus-read (ldb (byte 8 24.) adr) (ldb (byte 24. 0) adr)))

(defun nuwrite32 (adr val)
  (%nubus-write (ldb (byte 8 24.) adr) (ldb (byte 24. 0) adr) val))

(defvar *mac-conf-stop-loc*)
(defvar *mac-conf-blk*)
(defvar *mac-conf-blk-size*)

(defun read-mac-conf (&optional (and-print t))
  (let ((adr #xfb000000))
    (if (not (= (macread32 adr) #x12345678))
        (ferror nil "not mac conf"))
    (if (not (= (macread32 (+ adr 4)) 5))
        (ferror nil "bad mac conf version"))
    (setq *mac-conf-stop-loc* (+ adr 8))
    (setq *mac-conf-blk* (macread32 (+ adr 12.)))
    (setq *mac-conf-blk-size* (macread32 (+ adr 16.))))
  (if and-print
      (format t "~&stop loc ~x; blk ~x; blk size ~d" *mac-conf-stop-loc* *mac-conf-blk* *mac-conf-blk-size*)))

(defun stop-mac ()
  (read-mac-conf)
  (%nubus-write (ldb (byte 8 24.) *mac-conf-stop-loc*) (ldb (byte 24. 0) *mac-conf-stop-loc*) 1))

(defun beg-of-line ()
  (send *terminal-io*
        :set-cursorpos
        0
        (nth-value 1 (send *terminal-io* :read-cursorpos :character))
        :character)
  (send *terminal-io* :clear-eol))

(defun twoway ()
  (clear-map)
  (read-mac-conf)
  (format t "~&write and read a test pattern in remote memory")
  (format t "~&Using remote address #x~x" *mac-conf-blk*)
  (format t "~&Each pass writes and reads ~d. bytes" *mac-conf-blk-size*)
  (format t "~2%")
  (let ((pass 0)
        (error-count 0)
        (local-adr (mbc-map-adr *mac-conf-blk*)))
    (do-forever
      (cond (t (zerop (mod pass 10.))
             (send *terminal-io*
                   :set-cursorpos
                   0
                   (nth-value 1 (send *terminal-io* :read-cursorpos :character))
                   :character)
             (send *terminal-io* :clear-eol)
             (format t "pass ~d error-count ~d" pass error-count)))
      (cond ((not (zerop pass))
             (do ((i 0 (+ i 4))
                  (pat (- pass 1) (logand #xffffffff (+ pat 1))))
                 ((= i *mac-conf-blk-size*))
               (let ((val (nuread32 (+ local-adr i))))
                 (cond ((not (= val pat))
                        (write-config-reg 6)
                        (write-config-reg 2)
                        (incf error-count)
                        (format t "~&error ~d: pass ~d offset ~d expected #x~x got #x~x, then got #x~x~&"
                                error-count pass i pat val (nuread32 (+ local-adr i)))))))))
      (do ((i 0 (+ i 4))
           (pat pass (logand #xffffffff (+ pat 1))))
          ((= i *mac-conf-blk-size*))
        (nuwrite32 (+ local-adr i) pat))
      (incf pass))))

(defun twoway-lmap ()
  (clear-map)
  (read-mac-conf)
  (format t "~&write and read a test pattern in remote memory, and read and write to local map")
  (format t "~&Using remote address #x~x" *mac-conf-blk*)
  (format t "~&Each pass writes and reads ~d. bytes" *mac-conf-blk-size*)
  (format t "~2%")
  (let ((pass 0)
        (error-count 0)
        (local-adr (mbc-map-adr *mac-conf-blk*))
        (testslot (* 4 (alloc-mbc-slot))))
    (format t "~&map testslot = ~x~%" testslot)
    (do-forever
      (cond (t (zerop (mod pass 10.))
             (send *terminal-io*
                   :set-cursorpos
                   0
                   (nth-value 1 (send *terminal-io* :read-cursorpos :character))
                   :character)
             (send *terminal-io* :clear-eol)
             (format t "pass ~d error-count ~d" pass error-count)))
      (cond ((not (zerop pass))
             (do ((i 0 (+ i 4))
                  (pat (- pass 1) (logand #xffffffff (+ pat 1))))
                 ((= i *mac-conf-blk-size*))
               (let ((val (nuread32 (+ local-adr i))))
                 (cond ((not (= val pat))
                        (incf error-count)
                        (format t "~&error ~d: pass ~d offset ~d expected #x~x got #x~x~&"
                                error-count pass i pat val)))))
             (do ((i 1 (+ i 1))
                  (pat (logand (- pass 1) #xfe) (+ pat 2)))
                 ((= i 128))
               (let ((val (read-map (* i 4))))
                 (cond ((not (= val (logand pat #xfe)))
                        (format t "~&error ~d: local map #x~x expected #x~x got #x~x~&"
                                error-count i (logand pat #xfe) val)))))))
      (do ((i 0 (+ i 4))
           (pat pass (logand #xffffffff (+ pat 1))))
          ((= i *mac-conf-blk-size*))
        (nuwrite32 (+ local-adr i) pat))
      (do ((i 1 (+ i 1))
           (pat (logand pass #xfe) (+ pat 2)))
          ((= i 128))
        (write-map (* i 4) pat))
      (incf pass))))

(defun twoway-rmap ()
  (clear-map)
  (read-mac-conf)
  (format t "~&write and read a test pattern in remote memory, and read and write to local map")
  (format t "~&Using remote address #x~x" *mac-conf-blk*)
  (format t "~&Each pass writes and reads ~d. bytes" *mac-conf-blk-size*)
  (format t "~2%")
  (let ((pass 0)
        (error-count 0)
        (local-adr (mbc-map-adr *mac-conf-blk*))
        (testslot (* 4 (alloc-mbc-slot))))
    (format t "~&map testslot = ~x~%" testslot)
    (do-forever
      (cond (t (zerop (mod pass 10.))
             (send *terminal-io*
                   :set-cursorpos
                   0
                   (nth-value 1 (send *terminal-io* :read-cursorpos :character))
                   :character)
             (send *terminal-io* :clear-eol)
             (format t "pass ~d error-count ~d" pass error-count)))
      (cond ((not (zerop pass))
             (do ((i 0 (+ i 4))
                  (pat (- pass 1) (logand #xffffffff (+ pat 1))))
                 ((= i *mac-conf-blk-size*))
               (let ((val (nuread32 (+ local-adr i))))
                 (cond ((not (= val pat))
                        (incf error-count)
                        (format t "~&error ~d: pass ~d offset ~d expected #x~x got #x~x~&"
                                error-count pass i pat val)))))
             (do ((i 1 (+ i 1))
                  (pat (logand (- pass 1) #xfe) (+ pat 2)))
                 ((= i 128))
               (let ((val (read-remote-map (* i 4))))
                 (cond ((and (zerop (logand val 1))
                             (not (= val (logand pat #xfe))))
                        (format t "~&error ~d: local map #x~x expected #x~x got #x~x then got #x~x~&"
                                error-count i (logand pat #xfe) val (read-remote-map (* i 4)))))))))
      (do ((i 0 (+ i 4))
           (pat pass (logand #xffffffff (+ pat 1))))
          ((= i *mac-conf-blk-size*))
        (nuwrite32 (+ local-adr i) pat))
      (do ((i 1 (+ i 1))
           (pat (logand pass #xfe) (+ pat 2)))
          ((= i 128))
        (let ((old (read-remote-map (* i 4))))
          (cond ((zerop (logand old 1))
                 (write-remote-map (* i 4) pat)))))
      (incf pass))))


(defun mac-inc ()
  (init-bc-tal)
  (clear-map)
  (read-mac-conf)
  (let ((ladr (mbc-map-adr *mac-conf-blk*)))
    (print-mbc-map)
    (format t "~&ladr = #x~x" ladr)
    (cond ((y-or-n-p "Continue? ")
           (do ((i 0 (+ i 1)))
               (())
             (nuwrite32 ladr i)
             (let ((val (nuread32 ladr)))
               (if (not (= val i))
                   (format t "~&error: expected #x~x got #x~x" i val))))))))

(defun mac-inc0 ()
  (do ((i 0 (+ i 1)))
      (())
    (%nubus-write 0 0 i)
    (let ((val (%nubus-read 0 0)))
      (if (not (= val i))
          (format t "~&error: expected #x~x got #x~x" i val)))))

(defun mac-read0 ()
  (init-bc-tal)
  (let ((ladr (mbc-map-adr 0)))
    (if (not (zerop ladr))
        (ferror nil "bad adr"))
    (format t "~&*0 = ~x" (%nubus-read 0 0))))

(defun mac-read ()
  (init-bc-tal)
  (clear-map)
  (let* ((radr 0)
         (ladr (mbc-map-adr radr))
         orig)
    (format t "~%looping reading address #x~x in mac~%" radr)
    (setq orig (nuread32 ladr))
    (do-forever (nuread32 ladr))))

(defun mac-read1 ()
  (init-bc-tal)
  (read-mac-conf)
  (let ((ladr (mbc-map-adr *mac-conf-blk*)))
    (print-mbc-map)
    (format t "~&going to loop reading mac adr #x~x (local #x~x)~&" *mac-conf-blk* ladr)
    (cond ((y-or-n-p "Continue? ")
           (do-forever (nuread32 ladr))))))

(defun mbc-init ()
  (init-bc-tal)
  (write-config-reg 2)
  (mbc-map-adr 0))

(defvar rqb1 nil)
(defvar rqb2 nil)

(defun disk-test ()
  (let ((error-count 0) (pass 0))
    (if (null rqb1) (setq rqb1 (si:get-disk-rqb 20.)))
    (if (null rqb2) (setq rqb2 (si:get-disk-rqb 20.)))
    (si:disk-read rqb1 0 0)
    (format t "~&")
    (do-forever
      (dotimes (x 4)
        (si:disk-read rqb2 0 0)
        (cond ((not (string-equal (array-leader rqb1 3) (array-leader rqb2 3)))
                (incf error-count))))
      (incf pass)
      (beg-of-line)
      (format t "pass ~d error count ~d" pass error-count))))

(defun pmap ()
  (dotimes (i 128.)
    (format t "~x " (read-map (* i 4)))))

(defsubst flash-led ()
  (write-config-reg 6)
  (write-config-reg 2))

(defun wones (&aux (win 0))
  (do-forever
    (%nubus-write 0 0 -1)
    (let ((x (%nubus-read 0 0)))
      (cond ((not (= x #xffffffff))
             (flash-led)
             (format t "~&win ~d " win)
             (setq win 0)
;            (y-or-n-p "~x continue? " x)
             )
            (t
             (incf win))))))

(defun rones ()
  (do-forever
    (if (not (= (%nubus-read 0 0) #xffffffff)) (return))))