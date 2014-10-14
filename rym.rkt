#lang racket

(require (planet neil/csv:2:0))

(provide main)

(define (eligible? album [year #f])
  (and (< 0 (string-length (eighth album))) (<= 7 (string->number (eighth album)))
       (if year (and (< 0 (string-length (seventh album))) (= (string->number (seventh album)) year)) #t)))

;; currently, integer weight in { 1,2,3,4 }
(define (weight album)
  (- (string->number (eighth album)) 6))

(define (sort-albums loa)
  (foldl (lambda (alb table)
           (define w (weight alb))
           (hash-set! table w (cons alb (hash-ref table w '()))) table)
         (make-hash) loa))

(define (shuffle-albums table)
  (hash-for-each table (lambda (k v)
                         (hash-set! table k (shuffle v)))) table)

(define (convert-probs lop [prob 0])
  (match lop
    ['() '()]
    [(cons p _) (cons (cons (car p) (+ prob (cdr p))) (convert-probs (rest lop) (+ prob (cdr p))))]))

(define (choose-albums table [n 10])
  (define denom (foldl + 0 (hash-map table (lambda (k v) (define l (length v)) (+ l (* (- k 1) l))))))
  (define probs (convert-probs
                 (sort (hash-map table(lambda (k v) (cons k (* k (length v)))))
                       (lambda (x y) (< (car x) (car y))))))
  (define (trav-probs r lop)
    (if (< r (cdr (first lop))) (car (first lop)) (trav-probs r (rest lop))))
  (define (choose n)
    (if (= n 0) '()
        (let
            ([w-chosen (trav-probs (random denom) probs)])
          (if (empty? (hash-ref table w-chosen)) (choose n)
              (let
                  ([a-chosen (first (hash-ref table w-chosen))])
                (hash-set! table w-chosen (rest (hash-ref table w-chosen)))
                (cons a-chosen (choose (- n 1))))))))
  (choose n))

(define (html-decode str)
  (regexp-replaces str '(("&amp;" "&"))))

(define (get-rym-data fname)
  (rest (csv->list (html-decode (file->string fname)))))

(define (stars r [n 0])
  (if (= n 5) (void)
      (begin
        (printf "~a"
                (cond
                  [(<= 1 (/ r 2)) #\u2605]
                  [(= 1/2 (/ r 2)) #\u272C]
                  [else #\u2606]))
        (stars (- r 2) (+ n 1)))))

(define (display-albums loa)
  (void (map (lambda (a) (stars (string->number (eighth a)))
               (printf ": ~a~a - ~a (~a)\n"
                       (if (< 0 (string-length (second a))) (format "~a " (second a)) "")
                       (third a) (sixth a) (seventh a))) loa)))
  
(define (main fname [n 10] [year #f])
  (display-albums
   (choose-albums
    (shuffle-albums
     (sort-albums (filter (curryr eligible? year) (get-rym-data fname)))) n)))
