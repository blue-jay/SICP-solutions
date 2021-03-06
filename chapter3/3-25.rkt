#lang planet neil/sicp

(define (assoc key records)
  (cond ((null? records) #f)
        ((equal? key (caar records)) (car records))
        (else (assoc key (cdr records)))))

(define (link-keys-value keys value)
  (define (iter k result)
    (if (null? k) result
        (iter (cdr k) (cons (car k) (list result)))))
  (iter (reverse keys) value))

(define (make-table)
  (let ((local-table (list '*table*)))
    
    (define (lookup . key)
      (define (iter keys subtable)
        (let ((inner-table 
               (assoc (car keys) (cdr subtable))))
          (if inner-table
              (if (null? (cdr keys)) 
                  inner-table
                  (iter (cdr keys) inner-table))
              #f)))
      (iter key local-table))
    
    (define (insert! value . key)
      (define (iter keys subtable)
        (cond ((null? (cdr subtable))
               
               (set-cdr! subtable (list (link-keys-value keys value))))
              ((not (list? (cadr subtable)))
               
               (set-cdr! subtable (list (link-keys-value keys value))))
              (else (let ((inner-table
                           (assoc (car keys) (cdr subtable))))
                      (if inner-table
                          (if (null? (cdr keys))
                              (set-cdr! inner-table (list value))
                              (iter (cdr keys) inner-table))
                          (set-cdr! subtable (cons (link-keys-value keys value)
                                                   (cdr subtable))))))))
      (iter key local-table))
    
    (define (dispatch m)
      (cond ((eq? m 'lookup-proc) lookup)
            ((eq? m 'insert-proc!) insert!)
            ((eq? m 'local-table) local-table)
            (else (error "Unknown operation -- TABLE" m))))
    dispatch))

(define (get table) (table 'lookup-proc))
(define (put table) (table 'insert-proc!))

(define t (make-table))

((get t) 'a)

((put t) 'value 'a)

(display (t 'local-table))
(newline)

((put t) 'value2 'b)

((get t) 'a)

(display (t 'local-table))
(newline)

((put t) 'value3 'a 'b)

((get t) 'a)

(define tt (t 'local-table))

(display (t 'local-table))

