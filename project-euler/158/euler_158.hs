import Data.Array

fact :: Integer -> Integer
fact n = product [2 .. n]

nCr :: Integer -> [Integer] -> Integer
nCr n k_s = fact(n) `div` (product [fact(x) | x <- ((n-sum(k_s)):k_s)])

after_bump_recurse :: Integer -> Integer -> Integer -> [(Integer,Integer)]
after_bump_recurse num remain multiplier = [(num+i,(nCr remain [i])) | i <- [0 .. remain]]

before_bump_recurse_helper :: Integer -> [[(Integer,Integer)]]
before_bump_recurse_helper n_COUNT = [(after_bump_recurse (count_of_elems_in_second_series_below_first_max + num_elems_in_e_series) (n_COUNT-(first_max_letter_idx+1)) (nCr first_max_letter_idx [count_of_elems_in_second_series_below_first_max, num_elems_in_e_series-1])) |
    first_max_letter_idx <- [1 .. n_COUNT-1],
    num_elems_in_e_series <- [1 .. first_max_letter_idx],
    num_letters_less_than_first_max_and_not_in_e_series <- [( first_max_letter_idx + 1 ) - num_elems_in_e_series],
    count_of_elems_in_second_series_below_first_max <- [1 .. num_letters_less_than_first_max_and_not_in_e_series]
    ]

before_bump_recurse :: Integer -> [Integer]
before_bump_recurse n_COUNT = elems arr where
        arr = accumArray (+) 0 (0,n_COUNT) (concat (before_bump_recurse_helper n_COUNT))

