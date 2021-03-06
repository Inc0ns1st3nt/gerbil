(export sugar-test)

(import :std/test
        :std/sugar)

(def sugar-test
  (test-suite "test :std/sugar"
   (test-case "chain"
    (check-equal?
     ;; expression as input
     (chain (iota 3)
            ([_ . rest] (map 1+ rest))
            (xs (map number->string xs))
            (string-join <> ", "))
     "2, 3")

    (check-equal?
     ;; variable as input
     (let (lst (iota 3))
       (chain lst
              ([_ . rest] (map 1+ rest))
              (xs (map number->string xs))
              (string-join <> ", ")))
     "2, 3")

    (check-equal?
     ;; chain lambda
     ((chain <>
             ([_ . rest] (map 1+ rest))
             (xs (map number->string xs))
             (string-join <> ", "))
      (iota 3))
     "2, 3")

    (check-equal?
     ;; destructuring lambda with pattern variable as input
     ((chain ([a . _] <> a)
             ([_ . rest] (map 1+ rest))
             (xs (map number->string xs))
             (string-join <> ", "))
      (list (iota 3) (iota 2)))
     "2, 3")

    (check-equal?
     ;; destructuring lambda with expression
     ((chain ([a b _] <> (list a b))
             ([_ . rest] (map 1+ rest))
             (xs (map number->string xs))
             (string-join <> ", "))
      (iota 3))
     "2")
    (check-equal? (chain [0 1] (map (lambda (v) (1+ v)) <>)) [1 2]))
   (test-case "test is"
    (check ((is 1+ 3) 2)                => #t)
    (check ((is 1+ number?) 0)          => #t)
    (check ((is symbol->string "a") 'a) => #t)
    (check ((is 1+ 3 test: eqv?) 2)     => #t)
    (check ((is 2) 2)                   => #t)
    (check ((is 'a test: eq?) 'a)       => #t)
    (check ((is 2.0) 2.0)               => #t)
    (check ((is "a") "a")               => #t))
   ))
