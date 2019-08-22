#lang racket

(define (atom? exp)
  (not (or (pair? exp) (null? exp) (vector? exp) (list? exp)))
)

;(atom? "asd")
;(atom? '(3))

(define (lat? exp)
  (cond 
    [(null? exp) true]
    [(and (atom? (car exp)) (lat? (cdr exp)))]
    [else false]
  )
)

;(lat? '(asd 4 j))
;(lat? '((asd 4 j)))

(define (member? a lat)
  (cond
    [(null? lat) false]
    [(or (eq? a (car lat)) (member? a (cdr lat)))]
    [else false]
  )
)

;(member? 4 '(2 3 4 5 6))
;(member? 8 '(2 3 4 5 6))
;(member? (quote asd) '(asd ef))

(define (rember a lat)
  (cond
    [(null? lat) '()]
    [(eq? a (car lat)) (cdr lat)]
    [else (cons (car lat) (rember a (cdr lat)))]
  )
)

;(rember 4 '(2 3 4 5 6))

(define (firsts arr)
  (cond
    [(null? arr) '()]
    [else (cons (car (car arr)) (firsts (cdr arr)))]
  )
)

;(firsts '(((five plums) four)(eleven green oranges)((no) more)))

(define (seconds arr)
  (cond
    [(null? arr) '()]
    [else (cons (car (cdr (car arr))) (seconds (cdr arr)))]
  )
)

;(seconds '(((five plums) four)(eleven green oranges)((no) more)))

(define (insertR new old lat)
  (cond
    [(null? lat) '()]
    [(eq? old (car lat)) (cons (car lat) (cons new (cdr lat))) ]
    [else (cons (car lat) (insertR new old (cdr lat)))]
  )
)

;(insertR (quote topping) (quote fudge) '(ice cream with fudge for dessert))

(define (insertL new old lat)
  (cond
    [(null? lat) '()]
    [(eq? old (car lat)) (cons new lat) ]
    [else (cons (car lat) (insertL new old (cdr lat)))]
  )
)

;(insertL (quote topping) (quote fudge) '(ice cream with fudge for dessert))

(define (subst new old lat)
  (cond
    [(null? lat) '()]
    [(eq? old (car lat)) (cons new (cdr lat))]
    [else (cons (car lat) (subst new old (cdr lat)))]
  )
)

;(subst (quote topping) (quote fudge) '(ice cream with fudge for dessert))

(define (subst2 new o1 o2 lat)
  (cond
    [(null? lat) '()]
    [(or (eq? o1 (car lat)) (eq? o2 (car lat))) (cons new (cdr lat))]
    [else (cons (car lat) (subst2 new o1 o2 (cdr lat)))]
  )
)

;(subst2 (quote vanilla) (quote chocolate) (quote banana)
;        '(banana ice cream with chocolate topping))

(define (multirember a lat)
  (cond
    [(null? lat) '()]
    [(eq? a (car lat)) (multirember a (cdr lat))]
    [else (cons (car lat) (multirember a (cdr lat)))]
  )
)

;(multirember (quote cup) '(coffee cup tea cup and hick cup))

(define (multiinsertR new old lat)
  (cond
    [(null? lat) '()]
    [(eq? old (car lat)) (cons (car lat) (cons new (multiinsertR new old (cdr lat))))]
    [else (cons (car lat) (multiinsertR new old (cdr lat)))]
  )
)

;(multiinsertR (quote topping) (quote fudge) '(fudge ice cream with fudge for dessert))

(define (multiinsertL new old lat)
  (cond
    [(null? lat) '()]
    [(eq? old (car lat)) (cons new (cons (car lat) (multiinsertL new old (cdr lat))))]
    [else (cons (car lat) (multiinsertL new old (cdr lat)))]
  )
)

;(multiinsertL (quote topping) (quote fudge) '(fudge ice cream with fudge for dessert))

(define (multisubst new old lat)
  (cond
    [(null? lat) '()]
    [(eq? old (car lat)) (cons new (multisubst new old (cdr lat)))]
    [else (cons (car lat) (multisubst new old (cdr lat)))]
  )
)

;(multisubst (quote topping) (quote fudge) '(fudge ice cream with fudge for dessert))

(define (add1 n)
  (+ n 1)
)

;(add1 7)

(define (sub1 n)
  (- n 1)
)

;(sub1 4)

(define (_+ x y)
  (cond
    [(zero? x) y]
    [else (_+ (sub1 x) (add1 y))]
  )
)

;(_+ 46 12)

(define (_- x y)
  (cond
    [(zero? y) x]
    [else (_- (sub1 x) (sub1 y))]
  )
)

;(_- 17 13)

(define (tup? tup)
  (cond
    [(null? tup) true]
    [(number? (car tup)) (tup? (cdr tup))]
    [else false]
  )
)

;(tup? '(3 4 5))
;(tup? '(3 "4" 5))
;(tup? '(3 (4 8) 5))

(define (addtup tup)
  (cond
    [(null? tup) 0]
    [else (_+ (car tup) (addtup (cdr tup)))]
  )
)

;(addtup '(15 6 7 12 3))

(define (_* x y)
  (cond
    [(zero? x) 0]
    [else (_+ y (_* (sub1 x) y))]
  )
)

;(_* 5 8)

(define (tup+ tup1 tup2)
  (cond
    [(null? tup1) tup2]
    [(null? tup2) tup1]
    [else (cons (_+ (car tup1) (car tup2)) (tup+ (cdr tup1) (cdr tup2)))]
  )
)

;(tup+ '(2 3 4 2) '(5 3 8 4))

(define (_> x y)
  (cond
    [(zero? x) false]
    [(zero? y) true]
    [else (_> (sub1 x) (sub1 y))]
  )
)

;(_> 5 8)
;(_> 12 8)
;(_> 8 8)

(define (_< x y)
  (cond
    [(zero? y) false]
    [(zero? x) true]
    [else (_< (sub1 x) (sub1 y))]
  )
)

;(_< 5 8)
;(_< 12 8)
;(_< 8 8)

(define (_= x y)
  (cond
    [(and (zero? x) (zero? y)) true]
    [(or (zero? x) (zero? y)) false]
    [else (_= (sub1 x) (sub1 y))]
  )
)

;(_= 5 9)
;(_= 5 5)

(define (__= x y)
  (cond
    [(_> x y) false]
    [(_< x y) false]
    [else true]
  )
)

;(_= 5 9)
;(_= 5 5)

(define (_^ x y)
  (cond
    [(zero? y) 1]
    [else (_* x (_^ x (sub1 y)))]
  )
)

;(_^ 5 3)

(define (_/ x y)
  (cond
    [(< x y) 0]
    [else (add1 (_/ (_- x y) y))]
  )
)

;(_/ 55 7)

(define (len lat)
  (cond
    [(null? lat) 0]
    [else (add1(len (cdr lat)))]
  )
)

;(len '(hotdogs with mustard sauerkraut and pickles ))

(define (pick n lat)
  (cond
    [(null? lat) false]
    [(zero? (sub1 n)) (car lat)]
    [else (pick (sub1 n) (cdr lat))]
  )
)

;(pick 0 '(lasagna spaghetti ravioli macaroni meatball))

(define (rempick n lat)
  (cond
    [(null? lat) '()]
    [(zero? (sub1 n)) (cdr lat)]
    [else (cons (car lat) (rempick (sub1 n) (cdr lat)))]
  )
)

;(rempick 0 '(lasagna spaghetti ravioli macaroni meatball))

(define (no-nums lat)
  (cond
    [(null? lat) '()]
    [(number? (car lat)) (no-nums (cdr lat))]
    [else (cons (car lat) (no-nums (cdr lat)))]
  )
)

;(no-nums '(5 pears 6 prunes 9 dates))

(define (all-nums lat)
  (cond
    [(null? lat) '()]
    [(number? (car lat)) (cons (car lat) (all-nums (cdr lat)))]
    [else (all-nums (cdr lat))]
  )
)

;(all-nums '(5 pears 6 prunes 9 dates))

(define (eqan? a1 a2)
  (cond
    [(and (number? a1) (number? a2)) (_= a1 a2)]
    [(or (number? a1) (number? a2)) false]
    [else (eq? a1 a2)]
  )
)

;(eqan? 3 "3")
;(eqan? "asd" "asd")
;(eqan? 45 45)

(define (occur a lat)
  (cond
    [(null? lat) 0]
    [(eqan? a (car lat)) (add1 (occur a (cdr lat)))]
    [else (occur a (cdr lat))]
  )
)

;(occur (quote asd) '(laskd asd frk asd eij fkd vf asd frjn))

(define (one? n)
  (eqan? n 1)
)

;(one? 1)

(define (rempick1 n lat)
  (cond
    [(null? lat) '()]
    [(one? n) (cdr lat)]
    [else (cons (car lat) (rempick1 (sub1 n) (cdr lat)))]
  )
)

;(rempick1 3 '(lasagna spaghetti ravioli macaroni meatball))

(define (rember* a arr)
  (cond
    [(null? arr) '()]
    [(atom? (car arr))
     (cond
       [(eqan? a (car arr)) (rember* a (cdr arr))]
       [else (cons (car arr) (rember* a (cdr arr)))]
     )
    ]
    [else (cons (rember* a (car arr)) (rember* a (cdr arr)))]
  )
)

;(rember* (quote cup) '((coffee) cup ((tea) cup) (and (hick)) cup))

(define (insertR* new old arr)
  (cond
    [(null? arr) '()]
    [(atom? (car arr))
     (cond
       [(eqan? old (car arr)) (cons (car arr) (cons new (insertR* new old (cdr arr))))]
       [else (cons (car arr) (insertR* new old (cdr arr)))]
     )
    ]
    [else (cons (insertR* new old (car arr)) (insertR* new old (cdr arr)))]
  )
)

#|
(insertR* (quote roast) (quote chuck) '((how much (wood))
could
((a (wood) chuck))
(((chuck)))
(if (a) ((wood chuck)))
could chuck wood))
|#

(define (occur* a arr)
  (cond
    [(null? arr) 0]
    [(atom? (car arr))
     (cond
       [(eqan? a (car arr)) (add1 (occur* a (cdr arr)))]
       [else (occur* a (cdr arr))]
     )
    ]
    [else (_+ (occur* a (car arr)) (occur* a (cdr arr)))]
  )
)

#|
(occur* (quote banana) '((banana)
(split ((((banana ice)))
(cream (banana))
sherbet))
(banana)
(bread)
(banana brandy)))
|#

(define (subst* new old arr)
  (cond
    [(null? arr) '()]
    [(atom? (car arr))
     (cond
       [(eqan? old (car arr)) (cons new (subst* new old (cdr arr)))]
       [else (cons (car arr) (subst* new old (cdr arr)))]
     )
    ]
    [else (cons (subst* new old (car arr)) (subst* new old (cdr arr)))]
  )
)

#|
(subst* (quote orange) (quote banana) '((banana)
(split ((((banana ice)))
(cream (banana))
sherbet))
(banana)
(bread)
(banana brandy)))
|#

(define (insertL* new old arr)
  (cond
    [(null? arr) '()]
    [(atom? (car arr))
     (cond
       [(eqan? old (car arr)) (cons new (cons old (insertL* new old (cdr arr))))]
       [else (cons (car arr) (insertL* new old (cdr arr)))]
     )
    ]
    [else (cons (insertL* new old (car arr)) (insertL* new old (cdr arr)))]
  )
)

#|
(insertL* (quote pecker) (quote chuck) '((how much (wood))
could
((a (wood) chuck))
(((chuck)))
(if (a) ((wood chuck)))
could chuck wood))
|#

(define (member* a arr)
  (cond
    [(null? arr) false]
    [(atom? (car arr))
     (cond
       [(eqan? a (car arr)) true]
       [else (member* a (cdr arr))]
     )
    ]
    [else (or (member* a (car arr)) (member* a (cdr arr)))]
  )
)

;(member* (quote chips) '((potato) (chips ((with) fish) (chips))))

(define (leftmost arr)
  (cond
    [(null? arr) false]
    [(atom? (car arr)) (car arr)]
    [else (leftmost (car arr))]
  )
)

;(leftmost '(((hot) (tuna (and))) cheese))
;(leftmost '((()) hot))

(define (eqlist? arr1 arr2)
  (cond
    [(and (null? arr1) (null? arr2)) true]
    [(or (null? arr1) (null? arr2)) false]
    [(and (atom? (car arr1)) (atom? (car arr2)))
     (and (eqan? (car arr1) (car arr2)) (eqlist? (cdr arr1) (cdr arr2)))
    ]
    [(or (atom? (car arr1)) (atom? (car arr2))) false]
    [else (and (eqlist? (car arr1) (car arr2)) (eqlist? (cdr arr1) (cdr arr2)))]
  )
)

;(eqlist? '((beef) ((sausage)) (and (soda)) and) '((beef) ((sausage)) (and (soda)) and))

(define (equal? s1 s2)
  (cond
    [(and (atom? s1) (atom? s2)) (and (eqan? s1 s2))]
    [(or (atom? s1) (atom? s2)) false]
    [else (eqlist? s1 s2)]
  )
)

;(equal? '((beef) ((sausage)) (and (soda)) and) '((beef) ((sausage)) (and (soda)) and))
;(equal? (quote asd) (quote asd))


(define (numbered? exp)
  (cond
    [(atom? exp) (number? exp)]
    [(eq? (quote +) (car (cdr exp)))
     (and (numbered? (car exp)) (numbered? (car (cdr (cdr exp)))))
    ]
    [(eq? (quote *) (car (cdr exp)))
     (and (numbered? (car exp)) (numbered? (car (cdr (cdr exp)))))
    ]
    [(eq? (quote ^) (car (cdr exp)))
     (and (numbered? (car exp)) (numbered? (car (cdr (cdr exp)))))
    ]
  )
)

;(numbered? '(3 + (4 * 5)))

(define (1-sub-exp exp)
  (car exp)
)

(define (2-sub-exp exp)
  (car (cdr (cdr exp)))
)

(define (op exp)
  (car (cdr exp))
)

(define (num_value exp)
  (cond
    [(atom? exp) exp]
    [(eq? (quote +) (op exp))
     (_+ (num_value (1-sub-exp exp)) (num_value (2-sub-exp exp)))
    ]
    [(eq? (quote *) (op exp))
     (_* (num_value (1-sub-exp exp)) (num_value (2-sub-exp exp)))
    ]
    [(eq? (quote ^) (op exp))
     (_^ (num_value (1-sub-exp exp)) (num_value (2-sub-exp exp)))
    ]
  )
)

;(num_value '((2 * (3 + 7)) + ((3 ^ 4) + 9)))

(define (_set lat)
  (cond
    [(null? lat) true]
    [(member? (car lat) (cdr lat)) false]
    [else (_set (cdr lat))]
  )
)

;(_set '(asd rgjrn asad asd))
;(_set '(asd rgjrn 4 asad 6 adsd))

(define (makeset lat)
  (cond
    [(null? lat) '()]
    [else (cons (car lat) (makeset (multirember (car lat) (cdr lat))))]
  )
)

;(makeset '(apple peach 3 pear peach plum 3 apple lemon 3 peach))

(define (subset? set1 set2)
  (cond
    [(null? set1) true]
    [else (and (member? (car set1) set2) (subset? (cdr set1) set2))]
  )
)

#|
(subset?
 '(5 chicken wings)
 '(5 hamburgers 2 pieces fried chicken and light duckling wings))

(subset?
 '(4 pounds of horseradish)
 '(four pounds chicken and 5 ou nces horseradish))
|#

(define (eqset? set1 set2)
  (and (subset? set1 set2) (subset? set2 set1))
)

;(eqset? '(6 large chickens with wings) '(6 chickens with large wings))

(define (intersect? set1 set2)
  (cond
    [(null? set1) false]
    [else (or (member? (car set1) set2) (intersect? (cdr set1) set2))]
  )
)

;(intersect? '(stewed tomatoes and macaroni) '( macaroni and cheese))
;(intersect? '(stewed tomatosses a3nd macarodfni) '( macaroni and cheese))

(define (intersect set1 set2)
  (cond
    [(null? set1) '()]
    [(member? (car set1) set2) (cons (car set1) (intersect (cdr set1) set2))]
    [else (intersect (cdr set1) set2)]
  )
)

;(intersect '(stewed tomatoes and macaroni) '( macaroni and cheese))
;(intersect '(stewed tomatosses a3nd macarodfni) '( macaroni and cheese))

(define (union set1 set2)
  (cond
    [(null? set1) set2]
    [(member? (car set1) set2) (union (cdr set1) set2)]
    [else (cons (car set1) (union (cdr set1) set2))]
  )
)

;(union '(stewed tomatoes and macaroni casserole) '( macaroni and cheese))
;(union '(stewed tomatosses a3nd macarodfni) '( macaroni and cheese))

(define (setdiff set1 set2)
  (cond
    [(null? set1) '()]
    [(member? (car set1) set2) (setdiff (cdr set1) set2)]
    [else (cons (car set1) (setdiff (cdr set1) set2))]
  )
)

;(setdiff '(stewed tomatoes and macaroni casserole) '( macaroni and cheese))
;(setdiff '(stewed tomatosses a3nd macarodfni) '( macaroni and cheese))

(define (intersectall set)
  (cond
    [(null? (cdr set)) (car set)]
    [else (intersect (car set) (intersectall (cdr set)))]
  )
)

#|
(intersectall '((6 pears and)
(3 peaches and 6 peppers)
(8 pears and 6 plums)
(and 6 prunes with some apples)))
|#

(define (a-pair? l)
  (cond
    [(atom? l) false]
    [(null? l) false]
    [(null? (cdr l)) false]
    [(null? (cdr (cdr l))) true]
    [else false]
  )
)

;(a-pair? '(9 (4 5)))

(define (rel? l)
  (cond
    [(null? l) true]
    [(and (_set l) (and (a-pair? (car l)) (rel? (cdr l))))]
    [else false]
  )
)

;(rel? '(apples peaches pumpkin pie))
;(rel? '((a pples peaches) (pumpkin pie) (apples peaches)))
;(rel? '((apples peaches) (pumpkin pie)))

(define (fun? rel)
  (and (rel? rel) (_set (firsts rel)))
)

;(fun? '((4 3) (4 2) (7 6) (6 2) (3 4) ))
;(fun? '((8 3) (4 2) (7 6) (6 2) (3 4) ))
;(fun? '((d 4) (b 0) (b 9) (e 5) (g 4) ))

(define (first a)
  (car a)
)

(define (second a)
  (car (cdr a))
)

(define (build a1 a2)
  (cons a1 (cons a2 '()))
)

(define (revpair p)
  (build (second p) (first p))
)

(define (revrel rel)
  (cond
    [(null? rel) '()]
    [else (cons (revpair (car rel)) (revrel (cdr rel)))]
  )
)

;(revrel '((8 a) (pumpkin pie) (got sick)))

(define (fullfun? fun)
  (and (rel? fun) (_set (seconds fun)))
)

;(fullfun? '((grape raisin) (plum prune) (stewed grape)))
;(fullfun? '((grape raisin) (plum prune) (stewed raisin)))

(define (rember-f test? a l)
  (cond
    [(null? l) '()]
    [(test? a (car l)) (cdr l)]
    [else (cons (car l) (rember-f test? a (cdr l)))]
  )
)
  
;(rember-f equal? '(pop corn) '(haha pop (pop corn)))

(define (eq?-c k)
  (lambda (x)
    (eq? x k)
  )
)

;((eq?-c (quote hello)) (quote hello))
;((eq?-c (quote hello)) (quote world))

(define rember-f1
  (lambda (test?)
    (lambda (a l)
      (cond
        [(null? l) '()]
        [(test? a (car l)) (cdr l)]
        [else (cons (car l) ((rember-f1 test?) a (cdr l)))]
      )
    )
  )
)

;((rember-f1 equal?) '(pop corn) '(haha pop (pop corn)))

(define insertL-f
  (lambda (test?)
    (lambda (new old l)
      (cond
        [(null? l) '()]
        [(test? old (car l)) (cons new l)]
        [else (cons (car l) ((insertL-f test?) new old (cdr l)))]
      )
    )
  )
)

;((insertL-f equal?) '(hello world) '(pop corn) '(haha pop (pop corn)))

(define insertR-f
  (lambda (test?)
    (lambda (new old l)
      (cond
        [(null? l) '()]
        [(test? old (car l)) (cons old (cons new (cdr l)))]
        [else (cons (car l) ((insertR-f test?) new old (cdr l)))]
      )
    )
  )
)

;((insertR-f equal?) '(hello world) '(pop corn) '(haha pop (pop corn)))

(define seqL
  (lambda (new old l)
    (cons new (cons old l))
  )
)

(define seqR
  (lambda (new old l)
    (cons old (cons new l))
  )
)

(define insert-g
  (lambda (test? seq)
    (lambda (new old l)
      (cond
        [(null? l) '()]
        [(test? old (car l)) (seq new old (cdr l))]
        [else (cons (car l) ((insert-g test? seq) new old (cdr l)))]
      )
    )
  )
)

;((insert-g equal? seqL) '(hello world) '(pop corn) '(haha pop (pop corn)))
;((insert-g equal? seqR) '(hello world) '(pop corn) '(haha pop (pop corn)))

(define (insertL1-f test?)
  (insert-g test? seqL)
)

;((insertL1-f equal?) '(hello world) '(pop corn) '(haha pop (pop corn)))

(define (atom-to-func x)
  (cond
    [(eq? x (quote +)) _+]
    [(eq? x (quote *)) _*]
    [(eq? x (quote ^)) _^]
  )
)

(define (num_value1 exp)
  (cond
    [(atom? exp) exp]
    [((atom-to-func (op exp))
      (num_value1 (1-sub-exp exp)) (num_value1 (2-sub-exp exp)))
    ]
  )
)

;(num_value1 '((2 * (3 + 7)) + ((3 ^ 4) + 9)))

(define (multirember-f test?)
  (lambda (a lat)
    (cond
      [(null? lat) '()]
      [(test? a (car lat)) ((multirember-f test?) a (cdr lat))]
      [else (cons (car lat) ((multirember-f test?) a (cdr lat)))]
    )
  )
)

#|
((multirember-f equal?) '(pop corn)
  '(haha pop (pop corn) lala (hello world) (pop corn))
)
|#

(define (multirember-eq)
  (multirember-f eq?)
)

(define (eq?-tuna)
  (eq?-c (quote tuna))
)

(define (multiremberT test? lat)
  (cond
    [(null? lat) '()]
    [(test? (car lat)) (multiremberT test? (cdr lat))]
    [else (cons (car lat) (multiremberT test? (cdr lat)))]
  )
)

;(multiremberT (eq?-tuna) '(shrimp salad tuna salad and tuna))
;(multiremberT (eq?-c (quote salad)) '(shrimp salad tuna salad and tuna))

(define multirember&co
  (lambda (a lat col)
    (cond
      [(null? lat) (col '() '())]
      [(eq? a (car lat))
       (multirember&co a (cdr lat) (lambda (newlat seen)
                                     (col newlat (cons (car lat) seen))))]
      [else (multirember&co a (cdr lat) (lambda (newlat seen)
                                          (col (cons (car lat) newlat) seen)
                                        ))]
    )
  )
)

#|
(multirember&co (quote tuna) '(and tuna with tuna salad)
                (lambda (newlat seen) (values newlat seen)))
(multirember&co (quote tuna) '(and tuna with tuna salad)
                (lambda (newlat seen) (values (length newlat) (length seen))))
|#

(define multiinsertLR
  (lambda (new oldL oldR lat)
    (cond
      [(null? lat) '()]
      [(eq? oldL (car lat))
       (cons new (cons oldL (multiinsertLR new oldL oldR (cdr lat))))]
      [(eq? oldR (car lat))
       (cons oldR (cons new (multiinsertLR new oldL oldR (cdr lat))))]
      [else (cons (car lat) (multiinsertLR new oldL oldR (cdr lat)))]
    )
  )
)

;(multiinsertLR (quote he) (quote asd) (quote jn) '(lkj he ki asd nd jn asd))

(define (multiinsertLR&co new oldL oldR lat col)
  (cond
    [(null? lat) (col '() 0 0)]
    [(eq? oldL (car lat))
     (multiinsertLR&co new oldL oldR (cdr lat)
                       (lambda (newlat l r)
                         (col (cons new (cons oldL newlat)) (add1 l) r)))]
    [(eq? oldR (car lat))
     (multiinsertLR&co new oldL oldR (cdr lat)
                       (lambda (newlat l r)
                         (col (cons oldR (cons new newlat)) l (add1 r))))]
    [else (multiinsertLR&co new oldL oldR (cdr lat)
                            (lambda (newlat l r)
                              (col (cons (car lat) newlat) l r)))]
  )
)

#|
(multiinsertLR&co (quote cranberries) (quote fish) (quote chips)
  '(hello fish and chips with food) (lambda (newlat l r) (values newlat l r (_+ l r))))
|#

(define (evens-only* l)
  (cond
    [(null? l) '()]
    [(atom? (car l))
     (cond
       [(even? (car l)) (cons (car l) (evens-only* (cdr l)))]
       [else (evens-only* (cdr l))]
     )]
    [else (cons (evens-only* (car l)) (evens-only* (cdr l)))]
  )
)

;(evens-only* '((9 1 2 8) 3 10 ((9 9) 7 6) 2))

(define (evens-only*&co l col)
  (cond
    [(null? l) (col '() 0 1)]
    [(atom? (car l))
     (cond
       [(even? (car l)) (evens-only*&co (cdr l)
          (lambda (newl oddS evenP)
            (col (cons (car l) newl) oddS (_* (car l) evenP))
          )
       )]
       [else (evens-only*&co (cdr l)
          (lambda (newl oddS evenP)
            (col newl (_+ (car l) oddS) evenP)
          )
       )]
     )]
    [else (evens-only*&co (car l)
       (lambda (newl1 oddS1 evenP1)
         (evens-only*&co (cdr l)
            (lambda (newl2 oddS2 evenP2)
              (col (cons newl1 newl2) (_+ oddS1 oddS2) (_* evenP1 evenP2))
            )
       )))]
  )
)

#|
(evens-only*&co '((9 1 2 8) 3 10 ((9 9) 7 6) 2)
  (lambda (newl oddS evenP) (values newl oddS evenP)))
|#

(define (evens-odds*&co l col)
  (cond
    [(null? l) (col '() 0 '() 0)]
    [(atom? (car l))
     (cond
       [(even? (car l)) (evens-odds*&co (cdr l)
         (lambda (oddL oddS evenL evenS)
           (col oddL oddS (cons (car l) evenL) (_+ (car l) evenS))
         )
       )]
       [else (evens-odds*&co (cdr l)
         (lambda (oddL oddS evenL evenS)
           (col (cons (car l) oddL) (_+ (car l) oddS) evenL evenS)
         )
       )]
     )]
    [else (evens-odds*&co (car l)
       (lambda (oddL1 oddS1 evenL1 evenS1)
         (evens-odds*&co (cdr l)
            (lambda (oddL2 oddS2 evenL2 evenS2)
              (col (cons oddL1 oddL2) (_+ oddS1 oddS2)
                   (cons evenL1 evenL2) (_+ evenS1 evenS2))
            )
       )))]
  )
)

#|
(evens-odds*&co '((9 1 2 8) 3 10 ((9 9) 7 6) 2)
  (lambda (oddL oddS evenL evenS) (values oddL oddS evenL evenS)))
|#

(define (_pick a lat)
  (cond
    [(one? a) (car lat)]
    [else (_pick (sub1 a) (cdr lat))]
  )
)

;(_pick 2 '(2 4 5))

(define (keep-looking a n lat)
  (cond
    [(eq? a n) true]
    [(number? n) (keep-looking a (_pick n lat) lat)]
    [else false]
  )
)

(define looking
  (lambda (a lat)
    (keep-looking a (_pick 1 lat) lat)
  )
)

;(looking (quote caviar) '(6 2 4 caviar 5 7 3))
;(looking (quote caviar) '(6 2 grits caviar 5 7 3))

(define (shift x)
  (build (first (first x)) (build (second (first x)) (second x)))
)

;(shift '((a b) (c d)))

(define (align x)
  (cond
    [(atom? x) x]
    [(a-pair? (first x)) (align (shift x))]
    [else (build (first x) (align (second x)))] 
  )
)

;(align '((a b) (c d)))

(define (length* x)
  (cond
    [(null? x) 0]
    [(atom? (car x)) (add1 (length* (cdr x)))]
    [else (_+ (length* (car x)) (length* (cdr x)))]
  )
)

;(length* '((a b) c))

(define (length*1 x)
  (cond
    [(atom? x) 1]
    [else (_+ (length*1 (first x)) (length*1 (second x)))]
  )
)

;(length*1 '((a b) (c d)))

(define (weight* x)
  (cond
    [(atom? x) 1]
    [else (_+ (_* 2 (weight* (first x))) (weight* (second x)))]
  )
)

;(weight* '((a b) c))
;(weight* '(a (b c)))

(define (shuffle x)
  (cond
    [(atom? x) x]
    [(a-pair? (first x)) (shuffle (revpair x))]
    [else (build (first x) (shuffle (second x)))]
  )
)

;(shuffle '(a (b d)))

(define (lothar-conjecture n)
  (cond
    [(one? n) 1]
    [(even? n) (lothar-conjecture (_/ n 2))]
    [else (lothar-conjecture (add1 (_* n 3)))]
  )
)

;(lothar-conjecture 192097)

(define (wilhelm-conjecture n m)
  (cond
    [(zero? n) (add1 m)]
    [(zero? m) (wilhelm-conjecture (sub1 n) 1)]
    [else (wilhelm-conjecture (sub1 n) (wilhelm-conjecture n (sub1 m)))]
  )
)

;(wilhelm-conjecture 2 2)

(define (eternity x)
  (eternity x)
)

;infinite function
;(eternity 1)

#|
;y-combinator for length function
(((lambda (func)
  (lambda (arr)
    ((func func) arr)))
  (lambda (func)
   (lambda (arr)
     (cond
       [(null? arr) 0]
       [else (add1 ((func func) (cdr arr)))]))))
 '(2 f g 8 e2 f))

;y-combinator for multirember function
(((lambda (func)
  (lambda (a arr)
    ((func func) a arr)))
  (lambda (func)
   (lambda (a arr)
     (cond
       [(null? arr) '()]
       [(eq? a (car arr)) ((func func) a (cdr arr))]
       [else (cons (car arr) ((func func) a (cdr arr)))]))))
 (quote g) '(2 f g 8 e2 g f))
|#

(define (new-entry-build s l)
  (build s l)
)

;(new-entry-build '(a b c) '(a a a))

(define (lookup-in-entry-help n s l f)
  (cond
    [(null? s) (f n)]
    [(eq? (car s) n) (car l)]
    [else (lookup-in-entry-help n (cdr s) (cdr l) f)]
  )
)

(define (lookup-in-entry name entry func)
  (lookup-in-entry-help name (first entry) (second entry) func)
)

;(lookup-in-entry 'c '((a b c) (e r t)) (lambda (n)(values false)))
;(lookup-in-entry 'f '((a b c) (e r t)) (lambda (n)(values false)))

(define (extend-table entry table)
  (cons entry table)
)

;(extend-table '((a b)(c f)) '(((g t)(y y))))

(define (lookup-in-table name table func)
  (cond
    [(null? table) (func name)]
    [else (lookup-in-entry name (car table)
      (lambda (n)
        (lookup-in-table name (cdr table) func)))]
  )
)

#|
(lookup-in-table
 'f
 '(((a b c)(d r t)) ((q u b) (g t o)))
 (lambda (n) false))
|#

(define (expression-to-action e)
  (cond
    [(atom? e) (atom-to-action e)]
    [else (list-to-action e)]
  )
)

(define (atom-to-action e)
  (cond
    [(number? e) *const]
    [(eq? true e) *const]
    [(eq? false e) *const]
    [(eq? (quote true) e) *const]
    [(eq? (quote false) e) *const]
    [(eq? (quote car) e) *const]
    [(eq? (quote cdr) e) *const]
    [(eq? (quote cons) e) *const]
    [(eq? (quote add1) e) *const]
    [(eq? (quote sub1) e) *const]
    [(eq? (quote null?) e) *const]
    [(eq? (quote eq?) e) *const]
    [(eq? (quote atom?) e) *const]
    [(eq? (quote number?) e) *const]
    [(eq? (quote zero?) e) *const]
    [else *identifier]
  )
)

(define (list-to-action e)
  (cond
    [(atom? (car e))
     (cond
       [(eq? (quote quote) (car e)) *quote]
       [(eq? (quote lambda) (car e)) *lambda]
       [(eq? (quote cond) (car e)) *cond]
       [else *application]
     )]
    [else *application]
  )
)

(define (value e)
  (meaning e '())
)

(define (meaning e table)
  ((expression-to-action e) e table)
)

(define (*const e table)
  (cond
    [(number? e) e]
    [(eq? true e) true]
    [(eq? false e) false]
    [(eq? 'true e) true]
    [(eq? 'false e) false]
    [else (build 'primitive e)]
  )
)

(define (*identifier e table)
  (lookup-in-table e table (lambda (n) (car '())))
)

(define (*cond e table)
  (evcon (cdr e) table)
)

(define (*quote e table)
  (car (cdr e))
)

(define (*lambda e table)
  (build (quote non-primitive) (cons table (cdr e)))
)

(define (*application e table)
  (my_apply (meaning (first e) table) (evlis (cdr e) table))
)

(define table-of first)
(define formals-of second)
(define body-of third)

(define (evcon lines table)
  (cond
    [(else? (question-of (car lines)))
     (meaning (answer-of (car lines)) table)]
    [(meaning (question-of (car lines)) table)
     (meaning (answer-of (car lines)) table)]
    [else (evcon (cdr lines) table)]
  )
)

(define question-of first)
(define answer-of second)

(define (else? e)
  (cond
    [(atom? e) (eq? e 'else)]
    [else false]
  )
)

(define (evlis e table)
  (cond
    [(null? e) '()]
    [else (cons (meaning (car e) table) (evlis (cdr e) table))]
  )
)

(define (primitive? e)
  (eq? (car e) 'primitive)
)

(define (non-primitive? e)
  (eq? (car e) 'non-primitive)
)

(define (my_apply fun vals)
  (cond
    [(primitive? fun) (apply-primitive (second fun) vals)]
    [(non-primitive? fun) (apply-closure (second fun) vals)]
  )
)

(define (apply-primitive name vals)
  (cond
    [(eq? (quote car) name) (car (first vals))]
    [(eq? (quote cdr) name) (cdr (first vals))]
    [(eq? (quote cons) name) (cons (first vals) (second vals))]
    [(eq? (quote add1) name) (add1 (first vals))]
    [(eq? (quote sub1) name) (sub1 (first vals))]
    [(eq? (quote null?) name) (null? (first vals))]
    [(eq? (quote eq?) name) (eq? (first vals) (second vals))]
    [(eq? (quote atom?) name) (my_atom? (first vals))]
    [(eq? (quote number?) name) (number? (first vals))]
    [(eq? (quote zero?) name) (zero? (first vals))]
  )
)

(define (my_atom? x)
  (cond
    [(null? x) false]
    [(atom? x) true]
    [(eq? (car x) 'primitive) true]
    [(eq? (car x) 'non-primitive) true]
    [else false]
  )
)

(define (apply-closure cls vals)
  (meaning (body-of cls)
           (extend-table
             (build (formals-of cls) vals)
             (table-of cls)))
)

;(*cond '(cond (coffee klatsch) (else party))
;       '(((coffee) (true))((klatsch party) (5 (6)))))

(define (minUniqSum-helper arr temp)
  (cond
    [(null? arr) '()]
    [(member? (car arr) (rember (car arr) temp))
     (minUniqSum-helper (cons (add1 (car arr)) (cdr arr))
                        (subst (add1 (car arr)) (car arr) temp))]
    [else (cons (car arr) (minUniqSum-helper (cdr arr) temp))]
  )
)

(define (minUniqSum arr tomatch)
  (let ([res (minUniqSum-helper arr arr)])
    (values res (addtup res) (addtup tomatch) (eq? (addtup res) (addtup tomatch)))
  )
)

;(minUniqSum '(3 2 1 2 7 3 2 4 8 1 7) '(3 2 1 4 7 5 6 8 9 10 11))