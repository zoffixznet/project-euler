(asdf:oos 'asdf:load-op :iterate)
(use-package :iterate)

(format t "Total = ~A~%"
        (iter (for i from 1 to 100)
              (sum (* i i) into sum-squares)
              (sum i into mysum)
              (finally (return (- (* mysum mysum) sum-squares)))))
