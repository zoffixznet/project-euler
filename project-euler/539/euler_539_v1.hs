import Data.Char
import Data.Bits
import Data.List

p_l :: (Integer -> Int -> Integer)
p_l 1 is_left = 0
p_l l is_left = ((l .&. 0x1) .|. (toInteger is_left) .|. (sub `shiftL` 1)) where
        sub = p_l (l `shiftR` 1) (is_left `xor` 0x1)
