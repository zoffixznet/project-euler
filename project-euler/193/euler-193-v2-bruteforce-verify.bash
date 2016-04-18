#!/bin/bash
seq 1 "$((MAX * MAX))" | factor | perl -lane '$c++ if s/\A[^:]*://r !~ /( [0-9]+)\1(?: |\z)/; END { print $c; }'
