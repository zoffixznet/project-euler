#!/bin/bash

# Copyright by Shlomi Fish, 2018 under the Expat licence
# https://opensource.org/licenses/mit-license.php

grep ^Found | perl -lne 'print $1 if /n=([0-9]+)/' | sort -u | perl -lane '$s += $_; END{print$s}'
