#!/bin/bash
cat 132.log | perl -pe 's/.*:\s*//;s/\s+/\n/gms' | wc -l
