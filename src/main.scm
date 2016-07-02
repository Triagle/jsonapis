;; The main scheme file, for all the cool command line stuff
(declare (use jselect))
(declare (use httpapis))
(require-extension srfi-37)
(use srfi-37)
(define options
  '(;; help
    (option
     '(#\h "help") #f #f
     (lambda _
       (print "Usage musicfinder [option] ARG ...
-h --help     show this text
-s --search S Search itunes for S
")))))
(define (run args)
  (print (jselect '(trackName) (itunes-query (car args)))))
(run (cdr (argv)))
