import Data.Char
import Data.Bits
import Data.List

p_l :: (Integer -> Int -> Integer)
p_l 1 is_left = 0
p_l l is_left = ((l `and` 0x1) `or` is_left `or` (sub `shiftL` 1)) where
        sub = p_l (l >> 1) (is_left^0x1)
