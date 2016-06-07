;; itunes metdata extraction library
;; Searches the itunes api for music or inspects a given track, artist or collection id

(require-extension list-utils)
(require-extension http-client)
(require-extension medea)
(define itunes-search-api "https://itunes.apple.com/search")
(define (cons->http-opts cns)
  (string-append (symbol->string (car cns)) "=" (cdr cns)))
(define (build-query alist)
  (fold (lambda (item acc) (string-append acc "&" (cons->http-opts item))) (string-append "?" (cons->http-opts (car alist))) (cdr alist)))
(define (from search_func . opts)
  (define-values (json uri repsonse)
    (with-input-from-request itunes-search-api (cons (cons 'term search_func) (plist->alist opts)) read-string))
  (vector->list (cdr (car (cdr (read-json json) )))))
(define (i-select attributes from . conditionals)
  (map (lambda (i) (map (lambda (n) (assoc n i)) attributes)) from))
(define (where attribute predicate value)
  (lambda (from)
    (let ((func (cond
                 ((equal? predicate 'isnt) (lambda (a) (not (equal? (cdr (assoc attribute a)) value))))
                 ((equal? predicate 'is) (lambda (a) (equal? (cdr (assoc attribute a)) value)))
                 (#t (lambda (a) (predicate (cdr (assoc attribute a)) value))))))
      (filter func from))))
