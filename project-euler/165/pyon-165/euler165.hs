import Data.Int
import Data.List
import Data.Maybe
import Data.Ratio
import qualified Data.Set as S

type ExtCoord = Int64
type ExtPoint = [ExtCoord]
type Segment  = [ExtPoint]

type IntCoord = Ratio ExtCoord
type IntPoint = [IntCoord]

coords :: [ExtCoord]
coords = unfoldr next 290797
  where
    next s = Just (s' `mod` 500, s')
      where
        s' = s * s `mod` 50515093

segments :: [ExtCoord] -> [Segment]
segments (a:b:c:d:ts) = [[a,b], [c,d]] : segments ts
segments _            = []

unaligned :: ExtCoord -> ExtCoord -> Bool
unaligned b c
  | 0 < b && b < c = False
  | 0 > b && b > c = False
  | otherwise      = True

add, sub :: Segment -> ExtPoint
add [p1,p2] = zipWith (+) p1 p2
sub [p1,p2] = zipWith (-) p1 p2

mult :: ExtPoint -> Segment -> Segment
mult = zipWith $ map . (*)

intersection :: Segment -> Segment -> Maybe IntPoint
intersection s1@(p1:_) s2@(p2:_)
  | unaligned num1 den = Nothing
  | unaligned num2 den = Nothing
  | otherwise          = Just $ (% den) `map` add nums
  where
    [a,d] = sub s1
    [b,e] = sub s2
    [c,f] = sub [p1,p2]
    num1  = c*e - b*f
    num2  = c*d - a*f
    den   = a*e - b*d
    nums  = mult [den-num1, num1] s1

main :: IO ()
main = print . S.size . S.fromList . next . segments $ take 20000 coords
  where
    next []     = []
    next (x:xs) = current ++ next xs
      where
        current = catMaybes $ intersection x `map` xs