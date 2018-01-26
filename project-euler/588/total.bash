# Copyright by Shlomi Fish, 2018 under the Expat licence
# https://opensource.org/licenses/mit-license.php

perl -E 'say join("\t", map { oct("0b$_") } split/0{2,}/,(sprintf"%b", "1" . 0 x $_) =~ s#0+$##r) for 1 .. 18' | perl -lanE 'use IO::All qw/ io /; BEGIN{%h=(map { split } io->file("db")->getlines);}say join"\t",map{$h{$_}}@F' | perl -n -0777 -E 's#\t#*#g;s#\n#+#g;say eval$_.0'
