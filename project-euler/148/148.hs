pascal_triangle_inc :: [Int] -> [Int]
pascal_triangle_inc (x:[]) = [x,x]
pascal_triangle_inc (x:xs) = x:((x+y) `mod` 7):ys where
    y:ys = pascal_triangle_inc xs

total_pascal :: Int -> (Int, [Int])
total_pascal 1 = (1,[1])
total_pascal n = let (mid_sum, prev_pascal) = total_pascal (n-1)
                 in let this_pascal = pascal_triangle_inc prev_pascal
                    in (mid_sum + length( filter (\x -> x /= 0) this_pascal), this_pascal)
