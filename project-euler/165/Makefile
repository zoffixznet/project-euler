all:

haskell: euler_165

euler_165: euler_165.hs
	ghc -O3 $<

test:
	prove t/*.t

runtest:
	runprove t/*.t
