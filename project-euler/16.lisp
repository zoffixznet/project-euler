; This aims to be a solution for:
; http://projecteuler.net/index.php?section=problems&id=5
(asdf:oos 'asdf:load-op :iterate)
(use-package :iterate)

(defun digits-sum (num)
  (labels
    ((helper (n sum) 
        (if (zerop n)
          sum
          (helper (floor (/ n 10)) (+ sum (mod n 10))))))
    (helper num 0)))
    
(defun myfind ()
  (digits-sum (expt 2 1000)))

