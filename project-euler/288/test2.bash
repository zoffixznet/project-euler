# Copyright by Shlomi Fish, 2018 under the Expat licence
# https://opensource.org/licenses/mit-license.php

perl test2.pl | perl -lanE 'print if $F[-1] ne $F[-2]'
