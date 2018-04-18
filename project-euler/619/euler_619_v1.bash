let a=1000000 ; let b=1234567
# let a=1000; let b=1234

seq "$a" "$b" | factor | perl -lapE 's# ([0-9]+) \1\b##g' > db.txt
grep -cP '^([0-9]+):$' db.txt

proc()
{
    s="$1"
    shift
    d="$1"
    shift
    cat "$s" | perl -lanE 's/^\d+: *//;s/ /\n/g;say' | sort -n | uniq -c | perl -anE 'use IO::All; $h{$F[1]} = 1 if $F[0] == 1; END { say for keys%h;use List::Util qw/any/; open $i, "<", "'"$s"'"; while ($l = <$i>) { if (not any { $h{$_} } split/\s+/,$l) { $l >> io("'"$d"'"); } } }'
}

proc db.txt db2.txt
proc db2.txt db3.txt
