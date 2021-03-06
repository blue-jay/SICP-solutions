(define (accumulate op initial sequence)
  (if (null? sequence) 
      initial
      (op (car sequence)
          (accumulate op initial (cdr sequence)))))

;using horner'rule solving polynomial:

(define (horner-eval x coefficient-sequence)
  (accumulate (lambda (this-coeff higher-terms) 
                      (+ this-coeff (* higher-terms x)))
               0
              coefficient-sequence))

(display (horner-eval 2 (list 1 2 3)))
(newline)
