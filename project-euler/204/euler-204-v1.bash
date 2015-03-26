#!/bin/bash
seq 1 1000000000 | xargs factor | grep -vP ':.*?[0-9]{3}' | tee dump.txt | wc -l
