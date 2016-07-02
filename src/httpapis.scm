;; HTTP Apis required for this project
(declare (unit httpapis))
(require-extension http-client)
(require-extension medea)
(define youtube-api-url "https://www.googleapis.com/youtube/v3/search")
(define-syntax http-api
  (syntax-rules ()
      [(_ name name-result url search-term-accessor result-accessor result-transformer)
       (begin
         (define (name query . conditional-alist)
           (read-json (with-input-from-request url
                                               (cons (cons (quote search-term-accessor) query) conditional-alist) read-string)))
         (define (name-result from)
           (result-transformer (result-accessor from))))]))
(http-api
 itunes-query
 itunes-results
 "https://itunes.apple.com/search"
 term
 cdadr
 vector->list)
;; TODO implement Youtube HTTP Api (for some reason googleapis is not found?????)
