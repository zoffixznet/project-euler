import Data.Int
import Data.List

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

data Frac = Frac {
      frac_n :: Int64
    , frac_d :: Int64
} deriving (Show)

data Type_X_Only_Seg = Type_X_Only_Seg {
      x_Only_x :: Int64
    , x_Only_y1 :: Int64
    , x_Only_y2 :: Int64
} deriving (Show)

data Type_XY_Seg = Type_XY_Seg {
      xy_m :: Frac
    , xy_b :: Frac
    , xy_x1 :: Int64
    , xy_x2 :: Int64
} deriving (Show)

data CompiledSeg = CompX Type_X_Only_Seg
                 | CompXY Type_XY_Seg

-- gcd n m = if m < n then (gcd m n) else if m == 0 then n else (gcd m (n `mod` m))

signed_gcd n m = gcd (abs n) (abs m)

_reduce n d = let g = (signed_gcd n d) in let ret = (Frac (n `div` g) (d `div` g)) in
    let Frac nn dd = ret in
    (if nn == 0 then (Frac 0 1) else
        if dd < 0 then (Frac (-nn) (-dd)) else ret)

_mul (Frac xn xd) (Frac yn yd) = _reduce (xn*yn) (xd*yd)

_add (Frac xn xd) (Frac yn yd) = _reduce (xn*yd+xd*yn) (xd*yd)

_subtract x (Frac yd yn) = _add x (Frac (-yd)  yn)

_div x (Frac yn yd) = _mul x (Frac yd yn)

_lt x y = 0 > (frac_n (_subtract x y))
_eq x y = 0 == (frac_n (_subtract x y))

compile_segment :: Seg -> CompiledSeg
compile_segment (x1,y1,x2,y2) = (if (x1 == x2)
    then let y_s = (sort [y1,y2]) in (CompX $ Type_X_Only_Seg x1 (y_s!!0) (y_s!!1))
    else (CompXY $ Type_XY_Seg m bb (x_s!!0) (x_s!!1)) ) where
        m = _reduce (y2-y1) (x2-x1)
        bb = _subtract (Frac y1 1) (_mul m (Frac x1 1))
        x_s = sort [x1,x2]


mysegs = map compile_segment $ take 5000 segs

data Point = Point {
      point_x :: Frac
    , point_y :: Frac
} deriving (Show)


intersect_x :: Type_X_Only_Seg -> Type_XY_Seg -> [Point]
intersect_x (Type_X_Only_Seg x_ y1 y2) (Type_XY_Seg m b x1 x2) =
    (if (and [(_lt (Frac x1 1) x), (_lt x (Frac x2 1)), (_lt (Frac y1 1) y)
            ,(_lt y (Frac y2 1))])
            then [Point x y]
            else []
    ) where
        x = (Frac x_ 1)
        y = _add (_mul m x) b

intersect_xy :: Type_XY_Seg -> Type_XY_Seg -> [Point]

intersect_xy (Type_XY_Seg s1_m s1_b s1_x1 s1_x2) (Type_XY_Seg s2_m s2_b s2_x1 s2_x2) =
    if (_eq s1_m s2_m) then [] else
        let x = (_div (_subtract s2_b s1_b) (_subtract s1_m s2_m))
        in if and [
        (_lt (Frac s1_x1 1) x),
        (_lt x (Frac s1_x2 1)),
        (_lt (Frac s2_x1 1) x),
        (_lt x (Frac s2_x2 1))
        ] then
            [(Point x (_add s2_b (_mul s2_m x)))]
            else []

x_segs :: [Type_X_Only_Seg]
x_segs = foo mysegs where
    foo [] = []
    foo ((CompX a):xs) = a:(foo xs)
    foo (_:xs) = foo xs

xy_segs_sort s1_x1 s1_x2 s2_x1 s2_x2 | s1_x1 < s2_x1 = LT
                                     | s1_x1 > s2_x1 = GT
                                     | s1_x2 < s2_x2 = LT
                                     | s1_x2 > s2_x2 = GT
                                     | otherwise = EQ

xy_segs :: [Type_XY_Seg]
xy_segs = sortBy (\s1 -> \s2 -> xy_segs_sort (xy_x1 s1) (xy_x2 s1) (xy_x1 s2) (xy_x2 s2)) $ foo mysegs where
    foo [] = []
    foo ((CompXY a):xs) = a:(foo xs)
    foo (_:xs) = foo xs

get_points [] = []
get_points (s1:xs) = (concat [intersect_x s2 s1 | s2 <- x_segs]) ++
    (concat [intersect_xy s1 s2 | s2 <- takeWhile (\s2 -> (xy_x1 s2) < x2) xs]) where
        x2 = (xy_x2 s1)

points = sort [show p | p <- get_points xy_segs]

count_points [] = 0
count_points (x:[]) = 1
count_points (x:(y:xs)) = (if (x == y) then 0 else 1 ) + (count_points (y:xs))

count = count_points points
