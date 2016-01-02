import Data.Char
import Data.Bits
import Data.List

p_l :: (Integer -> Int -> Integer)
p_l 1 is_left = 0
p_l l is_left = ((l .&. 0x1) .|. (toInteger is_left) .|. (sub `shiftL` 1)) where
        sub = p_l (l `shiftR` 1) (is_left `xor` 0x1)

sum_from_2power_to_next :: Int -> Integer
sum_from_2power_to_next exp = naive_sum + cnt + digits_sum where
    mymin = 1 `shiftL` exp
    mymax = ((1 `shiftL` (exp+1)) - 1)
    cnt = (mymax - mymin + 1)
    naive_sum = ( (((mymax .&. (complement mymin))+0) * cnt) `shiftR` 1 )
    digits_sum = sum [((1 `shiftL` b_exp) * cnt) `shiftR` 1 | b_exp <- [0,2..exp-1]]

