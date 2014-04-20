sums :: [Integer]
sums = takeWhile (\x -> x <= 9*9*20) [x*x | x <- [1..]]

combos :: Integer -> Integer -> Integer -> [[Integer]]
combos 0 sum start = if (sum > 0) then [] else [[]]
combos len sum start = [(x:xs) | x <- filter (\x -> sum - x * x - 9*9*(len-1) <= 0) (takeWhile (\x -> x*x <= sum) [start .. 9]), xs <- combos (len-1) (sum - x*x) x]
