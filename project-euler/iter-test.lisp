; Copyright by Shlomi Fish, 2018 under the Expat licence
; https://opensource.org/licenses/mit-license.php

; This aims to test iterate
(asdf:oos 'asdf:load-op :iterate)
(use-package :iterate)

(iter (for i from 1 to 10)
      (format t "Hello No. ~A~%" i))
