;; The main scheme file, for all the cool command line stuff
(declare (uses jselect))
(declare (uses httpapis))
(require-extension fmt-unicode)
(require-extension fmt)
(require-extension srfi-37)
(use srfi-37)
(use fmt)
(use fmt-unicode)
(define help
 (option
  '(#\h "help") #f #f
  (lambda _
    (print "Usage musicfinder [option] ARG ...
-h --help     show this text
-s --search S Search itunes for S (S follows pattern artist - album - title)
")
    (exit))))
(define (print-table rows)
  (let ((rows (cons '((artistName . "Artist") (collectionName . "Album") (trackName . "Title")) rows)))
    (fmt #t (fmt-unicode (tabular
                          "| "
                          (dsp (string-join (map (lambda (r) (cdr (assoc 'artistName r))) rows) "\n"))
                          " | "
                          (dsp (string-join (map (lambda (r) (cdr (assoc 'collectionName r))) rows) "\n"))
                          " | "
                          (dsp (string-join (map (lambda (r) (cdr (assoc 'trackName r))) rows) "\n"))
                          " |")))))
(define search
  (option
   '(#\s "search") #t #f
   (lambda (option option-char query vals)
     (print-table (jselect '(artistName collectionName trackName) (itunes-results (itunes-query query))))
     vals)))

(define (run)
  (for-each
   (lambda (x) (print* x #\space))
   (reverse
    (args-fold
     (command-line-arguments)
     (list help search)
     (lambda (o n x vals)
       (error "unrecognized option" n) )
     cons
     '()))))
(run)
