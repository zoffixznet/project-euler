import Data.Int
import Data.List (nub , sort , sortBy)
import Data.Ratio



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

type Frac = Ratio Int64

frac :: Int64 -> Int64 -> Ratio Int64
frac = (%)

frac_n = numerator
frac_d = denominator

f n = frac n 1

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

_reduce n d = let g = (signed_gcd n d) in let ret = (frac (n `div` g) (d `div` g)) in
    let nn = frac_n ret in
    let dd = frac_d ret in
    (if nn == 0 then (f 0) else
        if dd < 0 then (frac (-nn) (-dd)) else ret)

compile_segment :: Seg -> CompiledSeg
compile_segment (x1,y1,x2,y2) = (if (x1 == x2)
    then let y_s = (sort [y1,y2]) in (CompX $ Type_X_Only_Seg x1 (y_s!!0) (y_s!!1))
    else (CompXY $ Type_XY_Seg m bb (x_s!!0) (x_s!!1)) ) where
        m = (y2-y1)%(x2-x1)
        bb = (f y1) - (m * (f x1))
        x_s = sort [x1,x2]


mysegs = map compile_segment $ take 5000 segs

data Point = Point {
      point_x :: Frac
    , point_y :: Frac
} deriving (Show)

instance Ord Point where
    compare (Point x1 y1) (Point x2 y2) =  compare (x1,y1) (x2,y2)

instance Eq Point where
    (Point x1 y1) == (Point x2 y2) = (x1,y1) == (x2,y2)

intersect_x :: Type_X_Only_Seg -> Type_XY_Seg -> [Point]
intersect_x (Type_X_Only_Seg x_ y1 y2) (Type_XY_Seg m b x1 x2) =
    (if (and [((f x1) < x), (x < (f x2)), ((f y1) < y)
            ,(y < (f y2))])
            then [Point x y]
            else []
    ) where
        x = (f x_)
        y = (m * x) + b

intersect_xy :: Type_XY_Seg -> Type_XY_Seg -> [Point]

intersect_xy (Type_XY_Seg s1_m s1_b s1_x1 s1_x2) (Type_XY_Seg s2_m s2_b s2_x1 s2_x2) =
    if s1_m == s2_m then [] else
        let x = ((s2_b - s1_b) / (s1_m - s2_m))
        in if and [
        ((f s1_x1) < x),
        (x < (f s1_x2)),
        ((f s2_x1) < x),
        (x < (f s2_x2))
        ] then
            [(Point x (s2_b + (s2_m * x)))]
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

get_points_helper [] = []
get_points_helper (s1:xs) = ((concat [intersect_x s2 s1 | s2 <- x_segs]) ++
    (concat [intersect_xy s1 s2 | s2 <- takeWhile (\s2 -> (xy_x1 s2) < x2) xs])) where
        x2 = (xy_x2 s1)

get_points [] = []
get_points (x:xs) = (get_points_helper (x:xs)):(get_points xs)

-- points = sort $ get_points xy_segs
points = concat $ get_points xy_segs

count = length (nub points)

main = putStrLn $ show count
