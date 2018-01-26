#!/bin/bash

# Copyright by Shlomi Fish, 2018 under the Expat licence
# https://opensource.org/licenses/mit-license.php

cat 132.log | perl -pe 's/.*:\s*//;s/\s+/\n/gms' | wc -l
