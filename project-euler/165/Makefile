# Copyright by Shlomi Fish, 2018 under the Expat licence
# https://opensource.org/licenses/mit-license.php
all:

haskell: euler_165

euler_165: euler_165.hs
	ghc -O3 $<

test:
	prove t/*.t

runtest:
	runprove t/*.t
