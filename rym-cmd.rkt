#lang racket

(require "rym.rkt")

(define year (make-parameter #f))
(define number (make-parameter "10"))

(define rym-file
  (command-line
   #:program "RYM"
   #:once-each
   [("-y" "--year") yr
                    "Filter albums by year"
                    (year yr)]
   [("-n" "--number") n
                      "Number of albums to fetch"
                      (number n)]
   #:args (filename)
   filename))

(main rym-file (string->number (number)) (if (year) (string->number (year)) (year)))

