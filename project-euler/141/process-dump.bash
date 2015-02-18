#!/bin/bash
grep ^Found | perl -lne 'print $1 if /n=([0-9]+)/' | sort -u | perl -lane '$s += $_; END{print$s}'
