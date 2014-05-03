import Data.Int

r_transform :: Int64 -> Int64

r_transform s_n = ((s_n * s_n) `mod` 50515093)

r :: Int64 -> [Int64]
r s_n = s_n:(r $ r_transform s_n)

get_t :: [Int64]
get_t = [x `mod` 500 | x <- (tail $ r 290797)]

type Seg = (Int64,Int64,Int64,Int64)

get_seg :: [Int64] -> [Seg]
get_seg (a:b:c:d:rest) = (a,b,c,d):(get_seg rest)

segs = get_seg get_t
