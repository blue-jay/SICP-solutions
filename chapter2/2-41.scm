#lang racket
(define (enumerate-interval low high)
  (if (> low high)
      null
      (cons low (enumerate-interval (+ low 1) high))))

(define (trans-list x) 
  (if (list? x)
      x
      (list x)))

(define (add-in x l)
  (map (lambda (y) (append (list x) (trans-list y))) l))

(display (add-in 2 (enumerate-interval 1 10)))
(newline)

(define (accumulate op initial sequence)
  (if (null? sequence) 
      initial
      (op (car sequence)
          (accumulate op initial (cdr sequence)))))



(define (3-list n) 
  (accumulate (lambda (x y) (append x y)) 
              null 
              (map (lambda (x) (add-in x 
                           (accumulate (lambda (a b) (append a b)) 
                                       null 
                                       (map (lambda (y) (add-in y (enumerate-interval 1 (- y 1)))) 
                                            (enumerate-interval 1 (- x 1)))))) 
       (enumerate-interval 1 n)))  )

;not very readible, need to simplify. fix me!!!!!

(display "3-list")
(newline)
(display (3-list 4))
(newline)

(define (sum-eq? l s) (= (accumulate + 0 l) s))

(display (sum-eq? '(1 2 3) 6))

(display (sum-eq? '(1 2 3) 5))
(newline)

(define (triples n s)
  (define (sum-eq-s? l) (sum-eq? l s))
  (filter sum-eq-s? (3-list n)))

(display (triples 6 10))
