# Copyright by Shlomi Fish, 2018 under the Expat licence
# https://opensource.org/licenses/mit-license.php

(
    MIN="1,000,000,000"
    MAX="9,999,999,999"
    primesieve -p1 "${MIN//,/}" "${MAX//,/}"
)
