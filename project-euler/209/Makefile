# Copyright by Shlomi Fish, 2018 under the Expat licence
# https://opensource.org/licenses/mit-license.php
all: connectivity.png

connectivity.png: euler-209-analysis-2.pl
	perl $< | perl -lpe 'BEGIN { print "graph foo {\n"; } ; s/=>/--/; s/([01]+)/"$$1"/g; END { print "\n}\n" }' | neato -Tpng > $@
