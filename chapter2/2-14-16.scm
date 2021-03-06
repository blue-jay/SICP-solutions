#lang racket
(newline)
(display "-----------2.14------------")
(newline)


(define (make-interval a b) (cons a b))

(define (lower-bound x) (car x))

(define (upper-bound x) (cdr x)) 

(define (make-center-percent c p)
  (make-interval (- c (* c p)) (+ c (* c p))))

(define (center i) (/ (+ (lower-bound i) (upper-bound i)) 2))

(define (percent x) (/ (- (upper-bound x) (lower-bound x)) (* (center x) 2)))

(define (mul-interval x y)
  (let ((p1 (lower-bound x))
        (p2 (upper-bound x))
        (p3 (lower-bound y)) 
        (p4 (upper-bound y))
        (b1 (> (lower-bound x) 0))
        (b2 (> (upper-bound x) 0))
        (b3 (> (lower-bound y) 0)) 
        (b4 (> (upper-bound y) 0)))
    (cond ((and b1 b2 b3 b4)             (make-interval (* p1 p3) (* p2 p4)))
          ((and b1 b2 (not b3) b4)       (make-interval (* p2 p3) (* p2 p4)))
          ((and b1 b2 (not b4))          (make-interval (* p2 p3) (* p1 p4)))
          ((and (not b1) b2 (not b3) b4) (make-interval (min (* p2 p3) (* p1 p4)) (max (* p2 p4) (* p1 p3))))
          ((and (not b1) b2 (not b3) (not b4)) (make-interval (* p2 p3) (* p1 p3)))
          ((and (not b1) (not b2) (not b3) (not b4)) (make-interval (* p2 p4) (* p1 p3)))
          (else (mul-interval y x)))))

(define (add-interval x y) 
  (make-interval (+ (lower-bound x) (lower-bound y))
                 (+ (upper-bound x) (upper-bound y))))

(define (sub-interval x y) 
  (make-interval (- (lower-bound x) (upper-bound y))
                 (- (upper-bound x) (lower-bound y))))

(define (div-interval x y)
  (mul-interval x
                (make-interval (/ 1.0 (upper-bound y))
                              (/ 1.0 (lower-bound y)))))

(define (div-interval-modify x y)
  (if (<= (* (lower-bound y) (upper-bound y)) 0)  
      (begin (display "error") (newline) #f)  ;give a "error" signal
      (div-interval x y))) 

;a test

(define a (make-interval 2.0 3.0))

(display (div-interval (make-interval 1 1) a))
(newline)

(define (par1 r1 r2)
  (div-interval (mul-interval r1 r2)
                (add-interval r1 r2)))

(define (par2 r1 r2)
  (let ((one (make-interval 1 1)))
    (div-interval one
                  (add-interval (div-interval one r1)
                                (div-interval one r2)))))

(define a (make-interval 1.99 2.01))

(define b (make-interval 2.97 3.03))

(display (par1 a b))
(newline)

(display (par2 a b))
(newline)

;it is different

(display (div-interval a b))
(newline)

(define one (make-interval 1 1))

(display (div-interval one (div-interval b a)))
(newline)

(newline)
(display "-----------2.15------------")
(newline)

;she is right. the same number has the same value, repeating will introduce error.

(newline)
(display "-----------2.16------------")
(newline)

;it is impossible... unless you can force all the formula having no same variable.
