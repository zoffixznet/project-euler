all: buf.txt

buf.txt:
	perl -E 'my $s = ""; $s .= $_ for 1 .. 1_000_000; say $s' > $@

test: buf.txt
	prove t/*.t
