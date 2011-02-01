maxRemainder a = 2 * a * ((a-1) `div` 2)
problem_120 = sum $ map maxRemainder [3..1000]
-- main = putStr $ unlines (map (\a -> (show(a) ++ " : " ++ show(maxRemainder a))) [3 .. 1000])
