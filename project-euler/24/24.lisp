; This aims to be a solution for:
; https://projecteuler.net/problem=24
(asdf:oos 'asdf:load-op :iterate)
(use-package :iterate)

(defun factorial (num)
  (labels
    ((helper (n prod)
             (if (= n 0) prod (helper (1- n) (* prod n)))))
    (helper num 1)))

(defun form-perm (remaining bit-vec)
  (
  (+ 5 6))
