#!/bin/bash

# Copyright by Shlomi Fish, 2018 under the Expat licence
# https://opensource.org/licenses/mit-license.php

seq 1 "$((MAX * MAX))" | factor | perl -lane '$c++ if s/\A[^:]*://r !~ /( [0-9]+)\1(?: |\z)/; END { print $c; }'
