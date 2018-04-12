#! /bin/bash
#
# 233-v1-test.bash
# Copyright (C) 2018 shlomif <shlomif@cpan.org>
#
# Distributed under terms of the MIT license.
#


i=0
while true
do
    let ++i
    echo "i=$i"
    have="$(python3 233-v1.py "$i")"
    want="$(perl 233-v1-brute.pl "$i")"
    if test "$have" != "$want"
    then
        echo "$have $want"
        exit -1
    fi
done
