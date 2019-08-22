#lang racket 
(require web-server/servlet)
(provide/contract (start (request? . -> . response?)))

(require "model.rkt")

(define (start request)
  (define path (build-path (current-directory-for-user) "blog-data.db"))
  (render-blog (initialize-blog! path)
    request))

(define (load-styles)
  '(link ((rel "stylesheet")
         (href "/blog-styles.css")
         (type "text/css"))))

(define (render-blog _blog request)
  (define (response-generator embed/url)
    (response/xexpr
     `(html
       (head (title "My Blog")
             ,(load-styles))
       (body (h1 "My Blog") ,(render-blog-posts _blog embed/url)
             (form ((action ,(embed/url insert-post-handler)))
              (input ((name "title")))
              (input ((name "body")))
              (input ((type "submit"))))))))
  (define (extractor key request)
    (extract-binding/single key (request-bindings request)))
  (define (insert-post-handler request)
    (blog-insert-post! _blog (extractor 'title request) (extractor 'body request))
    (render-blog _blog (redirect/get)))
  (send/suspend/dispatch response-generator))

(define (render-post-detail _blog _post request)
  (define (response-generator embed/url)
    (response/xexpr
     `(html
       (head (title "Post Details")
             ,(load-styles))
       (body (h1 "Post Details")
             (a ((href ,(embed/url handle-render-blog))) "Back")
             ,(render-post-info _post)
             (form ((action ,(embed/url insert-comment-handler)))
              (input ((name "comment")))
              (input ((type "submit"))))))))
  (define (handle-render-blog request)
    (render-blog _blog request))
  (define (extractor key request)
    (extract-binding/single key (request-bindings request)))
  (define (insert-comment-handler request)
    (render-confirm-add-comment
      _blog
      _post
      (extractor 'comment request)
      request))
  (send/suspend/dispatch response-generator))

(define (render-blog-posts _blog embed/url)
  (define (render-blog-posts/embed/url _post)
    (render-post _blog _post embed/url))
  `(div ((class "posts"))
        ,@(map render-blog-posts/embed/url (blog_model-posts _blog))))

(define (render-post _blog _post embed/url)
  (define (post-detail-handler request)
    (render-post-detail _blog _post request))
  `(div ((class "post"))
        (h4 ((class "title"))
            (a ((href ,(embed/url post-detail-handler)))
               ,(post_model-title _post)))
        (p ((class "body")) ,(post_model-body _post))
        (p ((class "comments-count"))
           ,(number->string (length  (post_model-comments _post)))
           " comment(s)")))

(define (render-post-info _post)
  `(div ((class "post-detail"))
        (h4 ((class "title")) ,(post_model-title _post))
        (p ((class "body")) ,(post_model-body _post))
        ,(render-post-comments _post)))

(define (render-post-comments _post)
  `(ul ((class "comments")) ,@(map render-comment (post_model-comments _post))))

(define (render-comment _item)
  `(li ((class "comment")) ,_item))

(define (render-confirm-add-comment _blog _post _comment request)
  (define (response-generator embed/url)
    (response/xexpr
      `(html
        (head (title "Add Comment Confirmation")
              ,(load-styles))
        (body (h1 "Add Comment Confirmation")
          (p
           "Add comment: '"
           ,_comment "' to post: '"
           ,(post_model-title _post) "'")
          (p (a ((href ,(embed/url add-comment))) "Add"))
          (p (a ((href ,(embed/url cancel-comment))) "Cancel"))))))
  (define (add-comment request)
    (post-insert-comment! _blog _post _comment)
    (render-post-detail _blog _post (redirect/get)))
  (define (cancel-comment request)
    (render-post-detail _blog _post request))
  (send/suspend/dispatch response-generator))

(require web-server/servlet-env)
(serve/servlet start
               #:launch-browser? #t
               #:quit? #f
               #:listen-ip #f
               #:port 8000
               #:extra-files-paths
               (list (current-directory-for-user))
               #:servlet-path
               "/server.rkt")