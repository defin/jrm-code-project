;;; -*- Mode:LISP; Package:TV; Base:8; Readtable:ZL -*-

;; this stuff used to live in sys:window;stream

;;; Hacked on 6/2/86 by RDM to make sure everything could deal with color pixels
;;; of size larger than one {mostly making sure everything takes a value or an
;;; ALU function containing the color}

(defflavor graphics-mixin () ()
  ;; explicit presence of sheet helps init the flavor-unmapped-instance-variables.
  (:required-flavors sheet essential-window)
  (:documentation :mixin
   "provides graphics output operations for windows."))

(defmethod (graphics-mixin :point) (x y)
  (setq x (+ x (sheet-inside-left)) y (+ y (sheet-inside-top)))
  (if (or (< x (sheet-inside-left)) ( x (sheet-inside-right))
          (< y (sheet-inside-top)) ( y (sheet-inside-bottom)))
      0
    (prepare-sheet (self)
      (ar-2-reverse screen-array x y))))

(defmethod (graphics-mixin :draw-point) (x y &optional (alu char-aluf) (value -1))
  (setq x (+ x (sheet-inside-left)) y (+ y (sheet-inside-top)))
  (or (< x (sheet-inside-left)) ( x (sheet-inside-right))
      (< y (sheet-inside-top)) ( y (sheet-inside-bottom))
      (prepare-sheet (self)
         (as-2-reverse (boole alu value (ar-2-reverse screen-array x y))
                       screen-array x y))))

;; copied from lad: release-3.window; graphics.lisp#9 on 2-oct-86 04:21:43
(defun draw-line-clip-visibility (point-x point-y)
  (declare (:self-flavor graphics-mixin))
  (logior (cond ((< point-x (sheet-inside-left)) 1)
                (( point-x (sheet-inside-right)) 2)
                (t 0))
          (cond ((< point-y (sheet-inside-top)) 4)
                (( point-y (sheet-inside-bottom)) 8)
                (t 0))))

;; copied from lad: release-3.window; graphics.lisp#9 on 2-oct-86 04:21:44
(defmethod (graphics-mixin :clip) (from-x from-y to-x to-y)
  (setq from-x (+ from-x (sheet-inside-left))
        from-y (+ from-y (sheet-inside-top))
        to-x (+ to-x (sheet-inside-left))
        to-y (+ to-y (sheet-inside-top)))
  (do ((from-visibility (draw-line-clip-visibility from-x from-y)
                        (draw-line-clip-visibility from-x from-y))
       (to-visibility (draw-line-clip-visibility to-x to-y))
       (exchanged nil))
      ;;when completely visible, draw the line
      ((and (zerop from-visibility) (zerop to-visibility))
       (and exchanged (psetq from-x to-x to-x from-x from-y to-y to-y from-y))
       (values (- from-x (sheet-inside-left))
               (- from-y (sheet-inside-top))
               (- to-x (sheet-inside-left))
               (- to-y (sheet-inside-top))))
    ;;if all off the screen, dont draw anything
    (or (zerop (logand from-visibility to-visibility)) (return (values nil nil nil nil)))
    ;;exchange points to try to make to point visible
    (and (zerop from-visibility)
         (psetq from-x to-x to-x from-x from-y to-y to-y from-y
                from-visibility to-visibility to-visibility from-visibility
                exchanged (not exchanged)))
    ;;if to-x = from-x then from-visibility = 0, 4 or 8 so there is no danger
    ;; of divide by zero in the next "push"
    (cond ((ldb-test #o0001 from-visibility)    ;push toward left edge
           (setq from-y (+ from-y (truncate (* (- to-y from-y) (- (sheet-inside-left) from-x))
                                            (- to-x from-x)))
                 from-x (sheet-inside-left)))
          ((ldb-test #o0101 from-visibility)    ;push toward right edge
           (setq from-y (+ from-y (truncate (* (- to-y from-y) (- (sheet-inside-right) from-x 1))
                                            (- to-x from-x)))
                 from-x (1- (sheet-inside-right)))))
    (cond ((ldb-test #o0201 from-visibility)    ;push toward top
           ;;it is possible that to-y = from-y at this point because of the effects of
           ;; the last "push", but in that case to-x is probably equal to from-x as well
           ;; (or at least close to it) so we needn't draw anything:
           (and (= to-y from-y) (return (values nil nil nil nil)))
           (setq from-x (+ from-x (truncate (* (- to-x from-x) (- (sheet-inside-top) from-y))
                                            (- to-y from-y)))
                 from-y (sheet-inside-top)))
          ((ldb-test #o0301 from-visibility)    ;push toward bottom
           ;; same:
           (and (= to-y from-y) (return (values nil nil nil nil)))
           (setq from-x (+ from-x (truncate (* (- to-x from-x) (- (sheet-inside-bottom) from-y 1))
                                            (- to-y from-y)))
                 from-y (1- (sheet-inside-bottom)))))))

;; copied from lad: release-3.window; graphics.lisp#9 on 2-oct-86 04:21:44
(defmethod (graphics-mixin :draw-line) (from-x from-y to-x to-y
                                        &optional (alu char-aluf) (draw-end-point t))
  (multiple-value-setq (from-x from-y to-x to-y)
    (send self :clip from-x from-y to-x to-y))
  (if from-x
      (prepare-sheet (self)
        (%draw-line (+ from-x (sheet-inside-left))
                    (+ from-y (sheet-inside-top))
                    (+ to-x (sheet-inside-left))
                    (+ to-y (sheet-inside-top))
                    alu draw-end-point self))))

;;; this never draws any end points, thus it is good for making closed polygons.
;;; calls the :draw-line method to do the clipping.
(defmethod (graphics-mixin :draw-lines) (alu x1 y1 &rest end-xs-and-ys)
  (do ((x2) (y2) (meth (get-handler-for self :draw-line))) ((null end-xs-and-ys))
    (setq x2 (car end-xs-and-ys)
          y2 (cadr end-xs-and-ys)
          end-xs-and-ys (cddr end-xs-and-ys))
    (funcall meth nil x1 y1 x2 y2 alu nil)
    (setq x1 x2
          y1 y2)))

(defmethod (graphics-mixin :draw-dashed-line)
           (x0 y0 x1 y1 &optional (alu char-aluf)
            (dash-spacing 20.) space-literally-p (offset 0)
            (dash-length (floor dash-spacing 2)))
  (let (n-dashes distance
        (real-dash-spacing dash-spacing)
        (real-dash-length dash-length)
        (meth (get-handler-for self ':draw-line)))
    (setq distance (sqrt (small-float (+ (^ (- x1 x0) 2) (^ (- y1 y0)  2)))))
    (if space-literally-p
        ;; get number of dashes of specified size that will fit.
        (setq n-dashes
              (floor (+ distance (- dash-spacing dash-length)) dash-spacing))
      ;; get approximate number of dashes that will fit,
      ;; then change spacing to make them fit exactly.
      (setq n-dashes (round (+ distance (- dash-spacing dash-length)) dash-spacing))
      (if (= n-dashes 1)
          (setq real-dash-spacing distance
                real-dash-length (- distance offset offset))
        (setq real-dash-spacing
              (// (- distance offset offset dash-length) (1- n-dashes)))))
    (let ((x (+ x0 (* offset (// (- x1 x0) distance))))
          (y (+ y0 (* offset (// (- y1 y0) distance))))
          (dx (* real-dash-length (// (- x1 x0) distance)))
          (dy (* real-dash-length (// (- y1 y0) distance)))
          (dx2 (* real-dash-spacing (// (- x1 x0) distance)))
          (dy2 (* real-dash-spacing (// (- y1 y0) distance))))
      ;the modifications (mainly from the draw-line method)
      (let ((il (sheet-inside-left))
            (it (sheet-inside-top)))
        (let ((from-x (+ x0 il)) (from-y (+ y0 it))
              (to-x (+ x1 il)) (to-y (+ y1 it)))
          (let ((from-visibility (draw-line-clip-visibility from-x from-y))
                (to-visibility (draw-line-clip-visibility to-x to-y)))
            (cond ;;when completely visible, draw the line internally
              ((and (zerop from-visibility) (zerop to-visibility))
               (prepare-sheet (self)
                 (let ((x (+ x il))
                       (y (+ y it)))
                   (dotimes (i n-dashes)
                     (%draw-line (fixr x) (fixr y) (fixr (+ x dx)) (fixr (+ y dy))
                                 alu (< (1+ i) n-dashes) self)
                     (incf x dx2)
                     (incf y dy2)))))           ;        suspect
              ;;if all off the screen, dont draw anything
              ((not (zerop (logand from-visibility to-visibility))))
              (t ;;otherwise, check for each dash
               (dotimes (i n-dashes)
                 (let ((from-x (fixr (+ x il))) (from-y (fixr (+ y it)))
                       (to-x (fixr (+ x dx il))) (to-y (fixr (+ y dy it))))
                   (let ((from-visibility (draw-line-clip-visibility from-x from-y))
                         (to-visibility (draw-line-clip-visibility to-x to-y)))
                     (cond ;;when completely visible, draw the dash internally
                       ((and (zerop from-visibility) (zerop to-visibility))
                        (prepare-sheet (self)
                          (%draw-line from-x from-y to-x to-y alu (< (1+ i) n-dashes) self)))
                       ;;if entire dash if off the screen, dont draw anything
                       ((not (zerop (logand from-visibility to-visibility))))
                       (t ;;otherwise draw a partial dash (doing this is slow)
                        (funcall meth ':draw-line (fixr x) (fixr y)
                                 (fixr (+ x dx)) (fixr (+ y dy))
                                 alu (< (1+ i) n-dashes))))))
                 (incf x dx2)
                 (incf y dy2))))))))))

;;; this clips in microcode
(defmethod (graphics-mixin :draw-triangle) (x1 y1 x2 y2 x3 y3 &optional (alu char-aluf))
  (prepare-sheet (self)
    (%draw-triangle (+ x1 (sheet-inside-left)) (+ y1 (sheet-inside-top))
                    (+ x2 (sheet-inside-left)) (+ y2 (sheet-inside-top))
                    (+ x3 (sheet-inside-left)) (+ y3 (sheet-inside-top))
                    alu self)))

;;; very special kludgey macro for :draw-circle.
(defmacro draw-clipped-point (x-form y-form)
  `(progn
     (setq x-val ,x-form
           y-val ,y-form)
     (or (< x-val il) ( x-val ir)
         (< y-val it) ( y-val ib)
         (as-2-reverse (boole alu value (ar-2-reverse screen-array x-val y-val))
                       screen-array x-val y-val))))

(defmethod (graphics-mixin :draw-circle)
           (center-x center-y radius &optional (alu char-aluf) (value -1))
  (let* ((il (sheet-inside-left))
         (it (sheet-inside-top))
         (ir (sheet-inside-right))
         (ib (sheet-inside-bottom))
         (center-x (+ center-x il))
         (center-y (+ center-y it)))
    (prepare-sheet (self)
      (do ((y 0)
           (x-val) (y-val)
           (f 0)                                ; f is just y squared without any multiplies
           (x radius))
          (nil)
        (draw-clipped-point (+ center-x x) (- center-y y))
        (draw-clipped-point (- center-x x) (+ center-y y))
        (draw-clipped-point (+ center-x y) (+ center-y x))
        (draw-clipped-point (- center-x y) (- center-y x))
        (setq f (+ f y y 1) y (1+ y))
        (if ( f x) (setq f (- f x x -1) x (- x 1)))
        (if (> y x) (return nil))
        (draw-clipped-point (+ center-x x) (+ center-y y))
        (draw-clipped-point (- center-x x) (- center-y y))
        (draw-clipped-point (+ center-x y) (- center-y x))
        (draw-clipped-point (- center-x y) (+ center-y x))
        (if (= y x) (return nil))))))

;;; faster method by drm@xx
;;; does not work for values 4. 11. 134. 373.
;;; i don't know why.  the old method below seems to work fine. -jrm
;;; ok, we tested this out and found that this code is measurably
;;; but not significantly faster.  comment out the bagbiter!
;(defmethod (graphics-mixin :draw-filled-in-circle)
;           (center-x center-y radius &optional (alu char-aluf))
;  (prepare-sheet (self)
;     (do ((x radius)
;         (y 0 (1+ y))
;         (error 0 (+ error y y 1))
;         old-y)
;        ((> y x))
;       (when ( error x)                       ; will the next chord be shorter?
;        ;; draw the middle region.
;        (if (null old-y)                       ; first time through, draw one big rectangle.
;            (draw-rectangle-inside-clipped (+ x x 1) (+ y y 1)
;                                           (- center-x x) (- center-y y) alu self)
;          ;; otherwise draw upper & lower rectangles.
;          (draw-rectangle-inside-clipped (+ x x 1) (- y old-y)
;                                         (- center-x x) (- center-y y) alu self)
;          (draw-rectangle-inside-clipped (+ x x 1) (- y old-y)
;                                         (- center-x x) (+ center-y old-y 1) alu self))
;        (setq old-y y)
;        (and (= x y) (return nil))             ;finished?
;        ;; draw the top line.
;        (draw-rectangle-inside-clipped (+ y y 1) 1
;                                       (- center-x y) (+ center-y x) alu self)
;        ;; draw the bottom line.
;        (draw-rectangle-inside-clipped (+ y y 1) 1
;                                       (- center-x y) (- center-y x) alu self)
;        (setq error (- error x x -1))
;        (decf x)))))

(defmethod (graphics-mixin :draw-filled-in-circle)
           (center-x center-y radius &optional (alu char-aluf))
  (let ((center-x (+ center-x (sheet-inside-left)))
        (center-y (+ center-y (sheet-inside-top))))
    (prepare-sheet (self)
      (do ((x 0)
           (f 0)                                ; f is just x^2. don't use multiplication!
           (y radius))
          ((> x y))
        (unless (= x y)
          (draw-rectangle-inside-clipped (+ y y 1) 1 (- center-x y) (+ center-y x)
                                         alu self)
          (unless (zerop x)
            (draw-rectangle-inside-clipped (+ y y 1) 1 (- center-x y) (- center-y x)
                                           alu self)))
        (setq f (+ f x x 1) x (1+ x))
        (when ( f y)
          (setq f (- f y y -1) y (- y 1))
          (draw-rectangle-inside-clipped (+ x x -1) 1
                                         (- center-x x -1) (+ center-y y 1)
                                         alu self)
          (draw-rectangle-inside-clipped (+ x x -1) 1
                                         (- center-x x -1) (- center-y y 1)
                                         alu self))))))


(defmethod (graphics-mixin :draw-circle-octant-arc)
           (center-x center-y radius &optional (alu char-aluf)
            right-up-start right-up-end top-right-start top-right-end
            top-left-start top-left-end left-up-start left-up-end
            left-down-start left-down-end bottom-left-start bottom-left-end
            bottom-right-start bottom-right-end right-down-start right-down-end (value -1))
  "draw a portion of each octant of a circle.
there is one pair of a -start and a -end argument for each octant,
which controls the portion of that octant which is actually drawn."
  (let* ((il (sheet-inside-left))
         (it (sheet-inside-top))
         (ir (sheet-inside-right))
         (ib (sheet-inside-bottom))
         (max-end (max right-up-end top-left-end left-down-end bottom-right-end
                       (- (// 3.14159s0 4)
                          (min right-down-end bottom-left-end
                               left-up-end top-right-end))))
         (center-x (+ center-x il))
         (center-y (+ center-y it)))
    (if (not (zerop radius))
        (prepare-sheet (self)
          (do ((y 0)
               (x-val) (y-val)
               angle
               (f 0)                            ; f is just r squared without any multiplies
               (x radius))
              (nil)
            (setq angle (atan2 (small-float y) (small-float x)))
            ;; octants counter clockwise from an axis
            (if (and (< angle right-up-end) ( angle right-up-start))
                (draw-clipped-point (+ center-x x) (- center-y y)))
            (if (and (< angle left-down-end) ( angle left-down-start))
                (draw-clipped-point (- center-x x) (+ center-y y)))
            (if (and (< angle bottom-right-end) ( angle bottom-right-start))
                (draw-clipped-point (+ center-x y) (+ center-y x)))
            (if (and (< angle top-left-end) ( angle top-left-start))
                (draw-clipped-point (- center-x y) (- center-y x)))
            (if (> angle max-end) (return nil))
            (setq f (+ f y y 1) y (1+ y))
            (if ( f x) (setq f (- f x x -1) x (- x 1)))
            (if (> y x) (return nil))
            ;; clockwise
            (setq angle (- (// 3.14159s0 4) angle))
            (if (and (< angle right-down-end) ( angle right-down-start))
                (draw-clipped-point (+ center-x x) (+ center-y y)))
            (if (and (< angle left-up-end) ( angle left-up-start))
                (draw-clipped-point (- center-x x) (- center-y y)))
            (if (and (< angle top-right-end) ( angle top-right-start))
                (draw-clipped-point (+ center-x y) (- center-y x)))
            (if (and (< angle bottom-left-end) ( angle bottom-left-start))
                (draw-clipped-point (- center-x y) (+ center-y x)))
            (if (= y x) (return nil)))))))

;draw a circular arc using the minsky algorithm (the present version tend to clip
;erroneously near window edges.  actually, the bug seems to be caused by the macro call
;to draw-clipped-point, which seems to sometimes "miss" il, it, ir, and ib).
;the ash's are multiplies or divides by 2 to the appropriate power.
;the internal arithmetic (accumulation) is done with actual figures (fixnums) multiplied
;by 2**10 for added precision.

(defmethod (graphics-mixin :draw-circular-arc)
           (center-x center-y radius start-theta end-theta &optional (alu char-aluf) (value -1)
            &aux (two-pi (* 2 3.14159s0)))
  ;alter theta's to their equivalents between 0 and 2pi.
  (multiple-value (nil start-theta) (floor start-theta two-pi))
  (multiple-value (nil end-theta) (floor end-theta two-pi))
  ;the ix variables are for the draw-clipped-point macro
  (let ((il (sheet-inside-left))
        (it (sheet-inside-top))
        (ir (sheet-inside-right))
        (ib (sheet-inside-bottom)))
    (let ((xc (+ center-x il))
          (yc (+ center-y it))
          (dtheta (if (> start-theta end-theta)
                      (- (+ end-theta two-pi) start-theta)
                    (- end-theta start-theta)))
          (rx (round (* (ash radius 10.) (cos start-theta))))
          (ry (- (round (* (ash radius 10.) (sin start-theta))))))
      (prepare-sheet (self)
        (loop ;2**sd is the angle of rotation. the + 2 and use of haulong = ceiling of log2
              ;is to make sure that the rotation is smaller than 1 pixel at the circumfrence
              with sd = (- (haulong (+ radius 2)))
              as xr = rx then (+ xr (ash yr sd))
              as yr = ry then (- yr (ash xr sd))
              repeat (ceiling (* dtheta (ash 1 (- sd))))
              do ; 512 causes rounding on the divide
                 (let ((x-val (+ xc (ash (+ xr 512.) -10.)))
                       (y-val (+ yc (ash (+ yr 512.) -10.))))
                   ;substituting the macro definition here seems to fix the bug
                   (or (< x-val il) (>= x-val ir)
                       (< y-val it) (>= y-val ib)
                       (as-2-reverse (boole alu value (ar-2-reverse screen-array x-val y-val))
                                     screen-array x-val y-val))))))))

(defmethod (graphics-mixin :draw-filled-in-sector) (center-x center-y radius theta-1 theta-2
                                                    &optional (alu char-aluf))
  (prepare-sheet (self)
    (do ((y (- radius) (1+ y))
         (x 0)
         (u0 0) (u1 0)                          ;clipped plane 1
         (v0 0) (v1 0)                          ;clipped plane 2
         (co-x0 (fix (* -1000.0 (sin theta-1))))
         (co-y0 (fix (*  1000.0 (cos theta-1))))
         (co-x1 (fix (* -1000.0 (sin theta-2))))
         (co-y1 (fix (*  1000.0 (cos theta-2))))
         (flag (> (abs (- theta-1 theta-2)) 3.14159))
         (r2 (* radius radius)))
        ((> y radius))
      (setq x (isqrt (- r2 (* y y))))           ;unclipped line
      (setq u0 (- x) u1 x
            v0 (- x) v1 x)                      ;init clipped lines

      (and (plusp (- (* co-y0 y) (* co-x0 u1))) ;clip with first plane
           (setq u1 (if (= 0 co-x0) 0 (truncate (* co-y0 y) co-x0))))
      (and (plusp (- (* co-y0 y) (* co-x0 u0)))
           (setq u0 (if (= 0 co-x0) 0 (truncate (* co-y0 y) co-x0))))

      (and (minusp (- (* co-y1 y) (* co-x1 v1)))        ;clip with second plane
           (setq v1 (if (= 0 co-x1) 0 (truncate (* co-y1 y) co-x1))))
      (and (minusp (- (* co-y1 y) (* co-x1 v0)))
           (setq v0 (if (= 0 co-x1) 0 (truncate (* co-y1 y) co-x1))))

      ;; ok, we have two lines, [u0 u1] and [v0 v1].
      ;; if the angle was greater than pi, then draw both of them,
      ;; otherwise draw their intersection
      (cond (flag
             (and (> u1 u0)
                  (send self :draw-line
                                (+ center-x u0) (+ center-y y)
                                (+ center-x u1) (+ center-y y)
                                alu t))
             (and (> v1 v0)
                  (send self :draw-line
                                (+ center-x v0) (+ center-y y)
                                (+ center-x v1) (+ center-y y)
                                alu t)))
            (t                                  ;compute intersection
             (let ((left  (max u0 v0))
                   (right (min u1 v1)))
               (and (> right left)
                    (send self :draw-line
                                  (+ center-x left)  (+ center-y y)
                                  (+ center-x right) (+ center-y y)
                                  alu t))))))))

;;; given an edge and a number of sides, draw something
;;; the sign of n determines which side of the line the figure is drawn on.
;;; if the line is horizontal, the rest of the polygon is in the positive direction
;;; when n is positive.
(defmethod (graphics-mixin :draw-regular-polygon) (x1 y1 x2 y2 n &optional (alu char-aluf)
                                                   &aux theta)
  (unless (zerop n)
    (setq theta (* 3.14159 (1- (// 2.0 n)))
          n (abs n))
    (prepare-sheet (self)
      (do ((i 2 (1+ i))
           (sin-theta (sin theta))
           (cos-theta (cos theta))
           (x0 x1) (y0 y1)
           (x3) (y3))
          (( i n))
        (setq x3 (+ (- (- (* x1 cos-theta)
                          (* y1 sin-theta))
                       (* x2 (1- cos-theta)))
                    (* y2 sin-theta))
              y3 (- (- (+ (* x1 sin-theta)
                          (* y1 cos-theta))
                       (* x2 sin-theta))
                    (* y2 (1- cos-theta))))
        (%draw-triangle (+ (sheet-inside-left) (fix x0)) (+ (sheet-inside-top) (fix y0))
                        (+ (sheet-inside-left) (fix x2)) (+ (sheet-inside-top) (fix y2))
                        (+ (sheet-inside-left) (fix x3)) (+ (sheet-inside-top) (fix y3))
                        alu self)
        (setq x1 x2 y1 y2
              x2 x3 y2 y3)))))

;;; display vectors of points
(defmethod (graphics-mixin :draw-curve) (px py &optional end (alu char-aluf)
                                         closed-curve-p)
  (or end (setq end (array-active-length px)))
  (let ((x0)
        (x1 (fix (aref px 0)))
        (y0)
        (y1 (fix (aref py 0)))
        (meth (get-handler-for self :draw-line)))
    (do ((i 1 (1+ i)))
        (( i end))
      (setq x0 x1)
      (or (setq x1 (aref px i)) (return nil))
      (setq x1 (fix x1))
      (setq y0 y1)
      (or (setq y1 (aref py i)) (return nil))
      (setq y1 (fix y1))
      (funcall meth nil x0 y0 x1 y1 alu nil))
    (when closed-curve-p
      (funcall meth nil x1 y1 (fix (aref px 0)) (fix (aref py 0)) alu nil))))

;;; display vectors of points
(defmethod (graphics-mixin :draw-closed-curve) (px py &optional end (alu char-aluf))
  (send self :draw-curve px py end alu t))

(defmethod (graphics-mixin :draw-wide-curve) (px py -width- &optional end (alu char-aluf)
                                              closed-curve-p)
  (or end (setq end (array-active-length px)))
  (setq -width- (// -width- 2.0s0))
  (prepare-sheet (self)
    (do ((i 0 (1+ i))
         (x0) (y0)
         (x1) (y1)
         (px1) (py1)
         (px2) (py2)
         (px3) (py3)
         (px4) (py4)
         exit-next-time)
        (exit-next-time)
      (setq x0 x1)
      (setq y0 y1)
      (if ( i end)
          (setq x1 nil y1 nil)
        (setq x1 (aref px i))
        (setq y1 (aref py i)))
      (unless (and x1 y1)
        ;; if we have passed the last point, either exit now or close the curve and then exit.
        (if closed-curve-p
            (setq x1 (aref px 0) y1 (aref py 0)
                  exit-next-time t)
          (return nil)))
      (unless (= i 0)
        (let ((dx (- x1 x0))
              (dy (- y1 y0))
              len)
          (setq len (small-float (sqrt (+ (* dx dx) (* dy dy)))))
          (and (zerop len) (= i 1) (setq len 1))
          (cond ((not (zerop len))
                 (psetq dx (// (* -width- dy) len)
                        dy (// (* -width- dx) len))
                 (if (= i 1)
                     (setq px1 (fix (- x0 dx)) py1 (fix (+ y0 dy))
                           px2 (fix (+ x0 dx)) py2 (fix (- y0 dy)))
                   (setq px1 px3 py1 py3 px2 px4 py2 py4))
                 (setq px3 (fix (- x1 dx)) py3 (fix (+ y1 dy))
                       px4 (fix (+ x1 dx)) py4 (fix (- y1 dy)))
                 (%draw-triangle (+ (sheet-inside-left) px1) (+ (sheet-inside-top) py1)
                                 (+ (sheet-inside-left) px2) (+ (sheet-inside-top) py2)
                                 (+ (sheet-inside-left) px4) (+ (sheet-inside-top) py4)
                                 alu self)
                 (%draw-triangle (+ (sheet-inside-left) px1) (+ (sheet-inside-top) py1)
                                 (+ (sheet-inside-left) px3) (+ (sheet-inside-top) py3)
                                 (+ (sheet-inside-left) px4) (+ (sheet-inside-top) py4)
                                 alu self))))))))

;;; cubic splines from rogers and adams, "mathematical elements
;;; for computer graphics".  this began as a translation from
;;; a basic program, but has been changed a bit.  the original
;;; program uses a full matrix inversion when the boundary conditions
;;; are cyclic or anti-cyclic, which is inefficient; in this version
;;; the special-case tridiagonal solver is extended to handle the
;;; cyclic and anti-cyclic end conditions.  (also, the original program
;;; has a bug wherein it neglects to initialize one diagonal of the m matrix.)

(defun spline (px py z &optional cx cy (c1 :relaxed) (c2 c1)
               p1-prime-x p1-prime-y pn-prime-x pn-prime-y
               &aux n n-1 n-2 n-3 bx by l ux uy n1 n2 n3 n4 sign
                    (zunderflow t) clen)
  "compute cubic splines.  px and py are arrays of x-coords and y-coords.
they describe a sequeuce of points through which a smooth
curve should be drawn.  this program generates z intermediate
points between each pair of points, returning a sequence of points
in cx and cy that includes the original points with the intermediate
points inserted.  the caller can then plot lines between successive
pairs of points of cx and cy to draw the curve.

the caller may pass in arrays to be filled in with the answers (used as
cx and cy); they should be (+ n (* z (- n 1))) long.  if nil is passed,
this function creates the arrays itself.  if they are not long enough,
they are adjusted with adjust-array-size.

the optional argument c1 is the initial end condition, one of
:relaxed, :clamped, :cyclic, or :anti-cyclic; c2 is the final end
condition, one of :relaxed or :clamped.  the first defaults to
:relaxed, and the second defaults to the first.  the second must be
the same as the first if the first is :cyclic or :anti-cyclic.  the
last four arguments are the x and y values to which the endpoints are
being clamped if the corresponding boundary condition is :clamped.
for cyclic splines that join themselves, the caller must pass the same
point twice, as both the first point and the last point.

p1-prime-x, etc., specify the slopes at the two endpoints,
for the sake of :clamped constraints.

three values are returned: the two arrays cx and cy, and the number
of active elements those arrays."
  (declare (values cx cy number-of-points))
  (setq n (array-active-length px)              ;the number of points
        n-1 (1- n)
        n-2 (1- n-1)
        n-3 (1- n-2))
  (setq clen (+ n (* n-1 z)))

  ;; create the arrays if they were not given them, or redimension them if needed.
  (cond ((null cx)
         (setq cx (make-array clen)))
        ((< (array-length cx) clen)
         (setq cx (adjust-array-size cx clen))))
  (cond ((null cy)
         (setq cy (make-array clen)))
        ((< (array-length cy) clen)
         (setq cy (adjust-array-size cy clen))))

  ;; set up l to hold the approximate spline segment lengths.
  ;; the nth element of l holds the distance between the nth and n+1st
  ;; points of px,py.  the last element of l is not used.
  (setq l (make-array n))
  (loop for j from 0 to n-2
        do (aset (small-float (sqrt (+ (^ (- (aref px (1+ j)) (aref px j)) 2)
                                       (^ (- (aref py (1+ j)) (aref py j)) 2))))
                 l j))

  ;; the bulk of the code here is concerned with solving a set of
  ;; simultaneous linear equations, expressed by the matrix equation
  ;; m * u = b.  m is an n by n square matrix, and b and u are n by 1
  ;; column matricies.  u will hold the values of the slope of the curve
  ;; at each point px, py.

  ;; the m matrix is tridiagonal for :relaxed and :clamped end conditions.
  ;; we represent it by storing m(i,i-1) in n1(i), m(i,i) in n2(i), and
  ;; m(i,i+1) in n3(i).  this means n1(0) and n3(n-1) are unused.
  (setq n1 (make-array n)
        n2 (make-array n)
        n3 (make-array n))

  ;; these quantities are meaningless, but they get referred to as part
  ;; of array bound conditions; these values just prevent errors from happening.
  (aset 0.0s0 n1 0)
  (aset 0.0s0 n3 n-1)

  (cond ((memq c1 '(:cyclic :anti-cyclic))
         ;; with these conditions, the m matrix is not quite tri-diagonal;
         ;; it is initialize with a 1 in the upper-right hand corner, and
         ;; during the solution of the equations the whole right column
         ;; gets non-zero values.  also, it is only n-1 by n-1!  so the upper
         ;; right corner is m(0, n-2).  n4 represents the n-2 column; element
         ;; m(i,n-2) is stored in n4(i).  the last two elements are not
         ;; used, because n4(n-2) = n2(n-2) and n4(n-3) = n3(n-3).  we also
         ;; set up this handy sign variable.
         (setq n4 (make-array (1- n)))
         (setq sign (if (eq c1 :cyclic) 1.0s0 -1.0s0)))
        ((not (memq c1 '(:relaxed :clamped)))
         (ferror nil "~s is not known spline type" c1)))
  ;; b is just a column vector, represented normally.
  (setq bx (make-array n)
        by (make-array n))

  ;; set up the boundary conditions.
  ;; the 0th row of m and b are determined by the initial boundary conditions,
  ;; and the n-1st row is determined by the final boundary condition.
  ;; note that the 0th row of m is implemented as the 0th element of n2, n3,
  ;; and sometimes n4; n1(0) is not used.  a similar thing is true of the
  ;; n-1st row.
  (selectq c1
    (:clamped
       (aset 1.0s0 n2 0)
       (aset 0.0s0 n3 0)
       (aset p1-prime-x bx 0)
       (aset p1-prime-y by 0))
    (:relaxed
       (aset 1.0s0 n2 0)
       (aset 0.5s0 n3 0)
       (let ((tem (// 3.0s0 (* 2.0s0 (aref l 0)))))
         (aset (* tem (- (aref px 1) (aref px 0))) bx 0)
         (aset (* tem (- (aref py 1) (aref py 0))) by 0)))
    ((:cyclic :anti-cyclic)
       (let ((s3 (// (aref l n-2) (aref l 0))))
         (aset (+ 2.0s0 (* s3 2.0s0)) n2 0)
         (aset s3 n3 0)
         (aset sign n4 0)
         (let ((tem (// 3.0s0 (aref l 0))))
           (aset (* tem (+ (* s3 (- (aref px 1) (aref px 0)))
                           (* sign (// (- (aref px n-1) (aref px n-2)) s3))))
                 bx 0)
           (aset (* tem (+ (* s3 (- (aref py 1) (aref py 0)))
                           (* sign (// (- (aref py n-1) (aref py n-2)) s3))))
                 by 0)))))
  (selectq c2
    (:clamped
       (aset 0.0s0 n1 n-1)
       (aset 1.0s0 n2 n-1)
       (aset pn-prime-x bx n-1)
       (aset pn-prime-y by n-1))
    (:relaxed
       (aset 2.0s0 n1 n-1)
       (aset 4.0s0 n2 n-1)
       (let ((tem (// 6.0s0 (aref l n-2))))
         (aset (* tem (- (aref px n-1) (aref px n-2))) bx n-1)
         (aset (* tem (- (aref py n-1) (aref py n-2))) by n-1)))
    ;; note: there are no final end conditions for :cyclic and :anti-cyclic,
    ;; since they are the same at each end.  the m matrix has no n-1st row,
    ;; either, as it is smaller by one row and one column.
    )

  ;; now fill in the insides of m and b arrays.
  (loop for j from 1 to n-2
        as l0 := (aref l 0) then l1
        as l1 := (aref l 1) then (aref l j)
        as px0 := (aref px 0) then px1
        as px1 := (aref px 1) then px2
        as px2 := (aref px (1+ j))
        as py0 := (aref py 0) then py1
        as py1 := (aref py 1) then py2
        as py2 := (aref py (1+ j))
        do (aset l1 n1 j)
           (aset (* 2 (+ l0 l1)) n2 j)
           (aset l0 n3 j)
           (if n4 (aset 0.0s0 n4 j))
           (aset (// (* 3.0s0 (+ (* (^ l0 2) (- px2 px1)) (* (^ l1 2) (- px1 px0))))
                     (* l0 l1)) bx j)
           (aset (// (* 3.0s0 (+ (* (^ l0 2) (- py2 py1)) (* (^ l1 2) (- py1 py0))))
                     (* l0 l1)) by j))

  ;; now that we have the matricies filled in, we solve the equations.
  ;; we use gaussian elimination, with a special version that takes
  ;; advantage of the sparsity of this tridiagonal or almost-tridiagonal
  ;; matrix to run in time o(n) instead of o(n**3).  no pivoting is used,
  ;; because for any real dat (not all zeroes, for example) the matrix
  ;; is both irreducible and diagonally-dominant, and therefore pivoting
  ;; is not needed (forsythe and moler, p. 117,  exercise 23.10).
  ;; the first step is to make the matrix upper-triangular, by making all of
  ;; n1 be zero.
  (let ((q (aref n2 0)))                                ;normalize row 0.
    (aset (// (aref n3 0) q) n3 0)
    (if n4 (aset (// (aref n4 0) q) n4 0))
    (aset (// (aref bx 0) q) bx 0)
    (aset (// (aref by 0) q) by 0))
  (loop for i from 1 to (if (null n4) n-1 n-2)
        as n1i := (aref n1 i)
        when (not (zerop n1i))                          ;if it is zero already, ok.
        do (let ((d (// 1.0s0 n1i)))
             ;; d = m(i-1, i-1) / m(i, i-1)  so multiply row i
             ;;   by d and subtract row i-1 from row i.
             (aset (- (* d (aref n2 i)) (aref n3 (1- i))) n2 i)
             (aset (* d (aref n3 i)) n3 i) ; uses n3(n-1), a garbage element.
             (cond (n4
                    (aset (- (* d (aref n4 i)) (aref n4 (1- i))) n4 i)
                    (if (= i n-3)
                        ;; in this case, n4(n-4) is above n3(n-3), so
                        ;; it must be subtracted out.
                        (aset (- (aref n3 i) (aref n4 (1- i))) n3 i))))
             (aset (- (* d (aref bx i)) (aref bx (1- i))) bx i)
             (aset (- (* d (aref by i)) (aref by (1- i))) by i)
             )
        ;; next normalize, by dividing row i through by m(i,i).
        ;; this leaves the center diagonal all 1.0s0, which the
        ;; back-solver in r&a doesn't take advantage of.
           (let ((q (aref n2 i)))
             (aset (// (aref n3 i) q) n3 i)
             (if n4 (aset (// (aref n4 i) q) n4 i))
             (aset (// (aref bx i) q) bx i)
             (aset (// (aref by i) q) by i)))

  ;; create the arrays to hold the answers.
  (setq ux (make-array n)               ;tangent vector matrix
        uy (make-array n))

  ;; backsolve the upper-triangular matrix.
  (cond ((not n4)
         ;; simpler version if there is no n4.
         (aset (aref bx n-1) ux n-1)
         (aset (aref by n-1) uy n-1)
         (loop for j from n-2 downto 0
               do (let ((n3j (aref n3 j)))
                    (aset (- (aref bx j) (* n3j (aref ux (1+ j)))) ux j)
                    (aset (- (aref by j) (* n3j (aref uy (1+ j)))) uy j))))
        (t
         ;; hairier version with n4.
         (let ((uxn-2 (aref bx n-2))
               (uyn-2 (aref by n-2)))
           (aset uxn-2 ux n-2)
           (aset uyn-2 uy n-2)
           (aset (- (aref bx n-3) (* (aref n3 n-3) uxn-2)) ux n-3)
           (aset (- (aref by n-3) (* (aref n3 n-3) uyn-2)) uy n-3)
           (loop for j from (1- n-3) downto 0
                 do (let ((n3j (aref n3 j))
                          (n4j (aref n4 j)))
                      (aset (- (aref bx j)
                               (* n3j (aref ux (1+ j)))
                               (* n4j uxn-2))
                            ux j)
                      (aset (- (aref by j)
                               (* n3j (aref uy (1+ j)))
                               (* n4j uyn-2))
                            uy j))))
         (aset (* sign (aref ux 0)) ux n-1)
         (aset (* sign (aref uy 0)) uy n-1)))

  (multiple-value (cx cy)
    (curgen n px py z cx cy l ux uy))           ; generate it

  (values cx cy clen))

;;; generate the spline curve points.
;;; this is a separate function because if it got merged, there would
;;; be too many local variables.
(defun curgen (n px py z cx cy l ux uy)
  (loop with i := 0
        for j from 0 to (- n 2)
        for len := (aref l j)
        for len^2 := (^ len 2)
        for len^3 := (* len^2 len)
        for fx1 := (aref px j)
        for fx2 := (aref ux j)
        for temx := (- (aref px (1+ j)) fx1)
        for temx1 := (+ (aref ux (1+ j)) fx2)
        for fx3 := (- (* (// 3.0s0 len^2) temx) (// (+ temx1 fx2) len))
        for fx4 := (+ (* (// -2.0s0 len^3) temx) (// temx1 len^2))
        for fy1 := (aref py j)
        for fy2 := (aref uy j)
        for temy := (- (aref py (1+ j)) fy1)
        for temy1 := (+ (aref uy (1+ j)) fy2)
        for fy3 := (- (* (// 3.0s0 len^2) temy) (// (+ temy1 fy2) len))
        for fy4 := (+ (* (// -2.0s0 len^3) temy) (// temy1 len^2))
        do (loop for k from 0 to z
                 for x from 0 by (// len (1+ z))
                 do (aset (+ fx1 (* fx2 x) (* fx3 (^ x 2)) (* fx4 (^ x 3))) cx i)
                    (aset (+ fy1 (* fy2 x) (* fy3 (^ x 2)) (* fy4 (^ x 3))) cy i)
                    (setq i (1+ i)))
        finally (progn (aset (small-float (aref px (1- n))) cx i)
                       (aset (small-float (aref py (1- n))) cy i)
                       (return (values cx cy)))))

(defmethod (graphics-mixin :draw-cubic-spline)
           (px py z &optional curve-width alu (c1 :relaxed) (c2 c1)
                       p1-prime-x p1-prime-y pn-prime-x pn-prime-y)
  (if (null curve-width)
      (setq curve-width 1))
  (if (null alu)
      (setq alu char-aluf))
  (multiple-value-bind (cx cy i)
      (spline px py z nil nil c1 c2 p1-prime-x p1-prime-y pn-prime-x pn-prime-y)
    (if (= curve-width 1)
        (send self :draw-curve cx cy i alu)
      (send self :draw-wide-curve cx cy curve-width i alu))))
