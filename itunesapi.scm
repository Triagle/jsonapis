;; itunes metdata extraction library
;; Searches the itunes api for music or inspects a given track, artist or collection id

(require-extension list-utils)
(define itunes-search-api "https://itunes.apple.com/search")
(define (cons->http-opts cns)
  (string-append (symbol->string (car cns)) "=" (cdr cns)))
(define (build-query alist)
  (fold (lambda (item acc) (string-append acc "&" (cons->http-opts item))) (string-append "?" (cons->http-opts (car alist))) (cdr alist)))
(define (select-tracks search_func . opts)
  (define-values (json uri repsonse)
    (with-input-from-request itunes-search-api (cons (cons 'term search_func) (plist->alist opts)) read-string))
  (cdr (car (cdr (read-json json) ))))
