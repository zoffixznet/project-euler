sums :: [Int]
sums = takeWhile (\x -> x < 9*9*20) [x*x | x <- [1..]]
