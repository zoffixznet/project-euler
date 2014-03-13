import Data.Array
import Text.Printf
import System.Environment

fact :: Integer -> Integer
fact n = product [1 .. n]

nCr :: Integer -> [Integer] -> Integer
nCr n k_s = fact(n) `div` (product [fact(x) | x <- ((n-sum(k_s)):k_s)])

after_bump_recurse :: Integer -> Integer -> Integer -> [(Integer,Integer)]
after_bump_recurse num remain factor =
    [(num+i,(factor*(nCr remain [i]))) | i <- [0 .. remain]]

before_bump_recurse_helper :: Integer -> [[(Integer,Integer)]]
before_bump_recurse_helper n_COUNT = [(after_bump_recurse (count_of_elems_in_second_series_below_first_max + e_elems_count) (n_COUNT-(first_max+1)) (nCr first_max [count_of_elems_in_second_series_below_first_max, (e_elems_count-1)])) |
    first_max <- [1 .. (n_COUNT-1)],
    e_elems_count <- [1 .. first_max],
    not_in_e_below_first_max <- [(( first_max + 1 ) - e_elems_count)],
    count_of_elems_in_second_series_below_first_max <- [1 .. not_in_e_below_first_max]
    ]

before_bump_recurse :: Integer -> [Integer]
before_bump_recurse n_COUNT = elems arr where
        arr = accumArray (+) 0 (0,n_COUNT) (concat (before_bump_recurse_helper n_COUNT))

before_str :: Integer -> String
before_str n = concat [(printf "Count[%2d] = %d\n" a b) | (a,b) <- (zip [0::Integer .. ] (before_bump_recurse n))]

main = getArgs >>= parse

parse (s:ss) = putStr $ before_str (read s :: Integer)
