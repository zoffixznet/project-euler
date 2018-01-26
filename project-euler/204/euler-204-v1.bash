#!/bin/bash

# Copyright by Shlomi Fish, 2018 under the Expat licence
# https://opensource.org/licenses/mit-license.php

seq 1 1000000000 | xargs factor | grep -vP ':.*?[0-9]{3}' | tee dump.txt | wc -l
