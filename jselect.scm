;; itunes metadata extraction library
;; Searches the itunes api for music or inspects a given track, artist or collection id

(require-extension list-utils)
(define (jselect attributes from . conditionals)
  ((foldl compose identity conditionals) (map (lambda (i) (map (lambda (n) (assoc n i)) attributes)) from)))
(define (where attribute predicate value)
  (lambda (from)
    (let ((func (cond
                 ((equal? predicate 'isnt) (lambda (a) (not (equal? (cdr (assoc attribute a)) value))))
                 ((equal? predicate 'is) (lambda (a) (equal? (cdr (assoc attribute a)) value)))
                 (#t (lambda (a) (predicate (cdr (assoc attribute a)) value))))))
      (filter func from))))
