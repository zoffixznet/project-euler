-- taken from http://www.haskell.org/haskellwiki/Euler_problems/141_to_150#Problem_144
--
type Point = (Double, Double)
type Vector = (Double, Double)
type Normal = (Double, Double)

sub :: Vector -> Vector -> Vector
sub (x,y) (a,b) = (x-a, y-b)

mull :: Double -> Vector -> Vector
mull s (x,y) = (s*x, s*y)

mulr :: Vector -> Double -> Vector
mulr v s = mull s v

dot :: Vector -> Vector -> Double
dot (x,y) (a,b) = x*a + y*b

normSq :: Vector -> Double
normSq v = dot v v

normalize :: Vector -> Vector
normalize v
    |len /= 0 =mulr v (1.0/len)
    |otherwise=error "Vettore nullo.\n"
    where
    len = (sqrt . normSq) v

proj :: Vector -> Vector -> Vector
proj a b = mull ((dot a b)/normSq b) b

reflect :: Vector -> Normal -> Vector
reflect i n = sub i $ mulr (proj i n) 2.0

type Ray = (Point, Vector)

makeRay :: Point -> Vector -> Ray
makeRay p v = (p, v)

getPoint :: Ray -> Double -> Point
getPoint ((px,py),(vx,vy)) t = (px + t*vx, py + t*vy)

type Ellipse = (Double, Double)

getNormal :: Ellipse -> Point -> Normal
getNormal (a,b) (x,y) = ((-b/a)*x, (-a/b)*y)

rayFromPoint :: Ellipse -> Vector -> Point -> Ray
rayFromPoint e v p = makeRay p (reflect v (getNormal e p))

test :: Point -> Bool
test (x,y) = y > 0 && x >= -0.01 && x <= 0.01

intersect :: Ellipse -> Ray -> Point
intersect (e@(a,b)) (r@((px,py),(vx,vy))) =
    getPoint r t1
    where
    c0 = normSq (vx/a, vy/b)
    c1 = 2.0 * dot (vx/a, vy/b) (px/a, py/b)
    c2 = (normSq (px/a, py/b)) - 1.0
    (t0, t1) = quadratic c0 c1 c2

quadratic :: Double -> Double -> Double -> (Double, Double)
quadratic a b c
    |d < 0= error "Discriminante minore di zero"
    |otherwise= if (t0 < t1) then (t0, t1) else (t1, t0)
    where
    d = b * b - 4.0 * a * c
    sqrtD = sqrt d
    q = if b < 0 then -0.5*(b - sqrtD) else 0.5*(b + sqrtD)
    t0 = q / a
    t1 = c / q

calculate :: Ellipse -> Ray -> Int -> IO ()
calculate e (r@(o,d)) n
    |test p=print n
    |otherwise=do
         putStrLn $ "\rHit " ++ show n
         calculate e (rayFromPoint e d p) (n+1)
    where
    p = intersect e r

origin = (0.0,10.1)
direction = sub (1.4,-9.6) origin
ellipse = (5.0,10.0)

problem_144 = do
    calculate ellipse (makeRay origin direction) 0
