#lang racket
(define (square x) (* x x))

(define (filter f s)
  (define (iter origin result)
    (if (null? origin) result
      (if (f (car origin))
          (iter (cdr origin) (append result (list (car origin))))
          (iter (cdr origin) result))))
  (iter s '()))

(define (enumerate-interval low high)
  (if (> low high)
      null
      (cons low (enumerate-interval (+ low 1) high))))

(define (flat-map proc seq)
  (accumulate append null (map proc seq)))

(define (accumulate op initial sequence)
  (if (null? sequence) 
      initial
      (op (car sequence)
          (accumulate op initial (cdr sequence)))))

(define (unique-pairs n)
  (flat-map 
    (lambda (i) 
      (map (lambda (j) (cons i j))
           (enumerate-interval 1 (- i 1))))
    (enumerate-interval 2 n)))

(display (unique-pairs 6))
(newline)

(define (make-pair-sum pair)
  (list (car pair) (cdr pair) (+ (car pair) (cdr pair))))

(define (expmod base exp m)
  (cond ((= exp 0) (remainder 1 m))
        ((even? exp)
        (remainder (square (expmod base (/ exp 2) m))
                   m))
        (else
        (remainder (* base (expmod base (- exp 1) m))
                   m))))

(define (fermat-test n)
  (define (try-it a) (= (expmod a n n) a))
  (try-it (+ 1 (random (- n 1)))))

;(display (fermat-test 5))

(define (fast-prime? n times)
  (cond ((= times 0) true)
        ((fermat-test n) (fast-prime? n (- times 1)))
        (else false)))

(define (prime? n) (fast-prime? n 10))

(define (prime-sum? pair)
  (prime? (+ (car pair) (cdr pair))))

(define (prime-sum-pairs n)
  (map make-pair-sum
       (filter prime-sum?
               (unique-pairs n))))

(display (prime-sum-pairs 6))
