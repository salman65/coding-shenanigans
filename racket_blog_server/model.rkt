#lang racket/base
(require racket/list)
(require db)

(struct post-model (blog id))

(struct blog-model (db))

(define (initialize-blog! home)
  (define cur_db (sqlite3-connect #:database home #:mode 'create))
  (define the-blog (blog-model cur_db))
  (unless (table-exists? cur_db "posts")
    (query-exec cur_db "create table posts (id integer primary key, title text, body text)")
    (blog-insert-post! the-blog "First" "First post")
    (blog-insert-post! the-blog "Second" "Second post"))
  (unless (table-exists? cur_db "comments")
    (query-exec cur_db "create table comments (pid integer, content text)")
    (post-insert-comment! the-blog (first (blog_model-posts the-blog)) "first comment"))
  the-blog)

#|
(define (save-blog! _blog)
  (define (write-to-blog)
    (write _blog))
  (with-output-to-file (blog_model-home _blog) write-to-blog #:exists 'replace))
|#

(define (blog-insert-post! _blog _title _body)
  (query-exec (blog-model-db _blog) "insert into posts (title, body) values (?,?)" _title _body))

(define (post-insert-comment! _blog _post _comment)
  (query-exec (blog-model-db _blog) "insert into comments (pid, content) values (?,?)" (post-model-id _post) _comment))

(define (blog_model-posts _blog)
  (define (id->post _id)
    (post-model _blog _id))
  (map id->post (query-list (blog-model-db _blog) "select id from posts")))

(define (post_model-title _post)
  (query-value (blog-model-db (post-model-blog _post)) "select title from posts where id=?" (post-model-id _post)))

(define (post_model-body _post)
  (query-value (blog-model-db (post-model-blog _post)) "select body from posts where id=?" (post-model-id _post)))

(define (comments-by-post _post)
  (query-list (blog-model-db (post-model-blog _post)) "select content from comments where pid=?" (post-model-id _post)))

(define (post_model-comments _post)
  (comments-by-post _post))

(provide
  blog-model? blog_model-posts
  post-model? post_model-title post_model-body post_model-comments
  initialize-blog!
  blog-insert-post!
  post-insert-comment!)