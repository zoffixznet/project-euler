all: connectivity.png

connectivity.png: euler-209-analysis-2.pl
	perl $< | perl -lpe 'BEGIN { print "graph foo {\n"; } ; s/=>/--/; s/([01]+)/"$$1"/g; END { print "\n}\n" }' | neato -Tpng > $@
