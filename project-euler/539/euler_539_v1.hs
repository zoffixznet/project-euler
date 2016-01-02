import Data.Char
import Data.Bits
import Data.List

p_l :: (Integer -> Int -> Integer)
p_l 1 is_left = 0
p_l l is_left = ((l .&. 0x1) .|. (toInteger is_left) .|. (sub `shiftL` 1)) where
        sub = p_l (l `shiftR` 1) (is_left `xor` 0x1)

sum_from_2power_to_next :: Int -> Integer
sum_from_2power_to_next exp = naive_sum + cnt + digits_sum where
    pow2 e = 1 `shiftL` e
    mymin = pow2 exp
    mymax = ((pow2 (exp+1)) - 1)
    cnt = (mymax - mymin + 1)
    naive_sum = ( (((mymax .&. (complement mymin))+0) * cnt) `shiftR` 1 )
    digits_sum = sum [((pow2 b_exp) * cnt) `shiftR` 1 | b_exp <- [0,2..exp-1]]

prefix_S_from_2power_to_next :: Integer -> Int -> Integer
prefix_S_from_2power_to_next prefix exp = ((sum_from_2power_to_next exp) + (cnt * (mymask2 .&. (complement (b_pow3 `shiftR` 1))))) where
    mymin = prefix `shiftL` exp
    mymax = mymin + ((1 `shiftL` exp) - 1)
    cnt = mymax - mymin + 1

    (init_b_exp,init_b_pow) = w (0,1) where
        w (b_exp,b_pow) = if (b_exp >= exp) then (b_exp, b_pow) else w ((b_exp+2),(b_pow `shiftL` 2))

    (b_exp2,b_pow2,mymask2) = w (init_b_exp,init_b_pow,mymin) where
        w (b_exp,b_pow,mymask) = if (b_pow >= mymin) then (b_exp,b_pow,mymask) else w (b_exp+2,(b_pow `shiftL`2),(mymask .|. b_pow))

    b_pow3 = w 1 where
        w b_pow = if b_pow > mymask2 then b_pow else w (b_pow `shiftL` 1)

fast_S :: Integer -> Integer
fast_S myMAX = s1 + s2 + s3 where -- s1 + s2 + s3 where
    (mymin1,mymax1,b_exp1,s1) = w (2,3,1,1) where
        w (mymin,mymax,b_exp,s) = if mymax >= myMAX then (mymin,mymax,b_exp-1,s) else w (new_mymin, ((new_mymin `shiftL` 1)-1), b_exp+1, s+sum_from_2power_to_next(b_exp)) where
                new_mymin = mymin `shiftL` 1
    p x = p_l x 1
    s2 = 1 + (p mymin1)
    s3 = w mymin1 b_exp1 (mymin1 `shiftR` 1) where
        w mymin b_exp digit = if (mymin >= myMAX) then 0 else delta_s + w new_mymin (b_exp-1) (digit `shiftR` 1) where
            myminer = (mymin .|. digit)
            cond = (myminer <= myMAX)
            new_mymin = if cond then myminer else mymin
            delta_s = if cond then ((p myminer) - (p mymin) + (prefix_S_from_2power_to_next (mymin `shiftR` b_exp) b_exp)) else 0
