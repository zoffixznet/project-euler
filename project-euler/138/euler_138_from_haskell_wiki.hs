{-
 - 4*m^2-16*m*n-4*n^2+1=0
 - 4*m^2-16*m*n-4*n^2-1=0
 - (m-2*n)^2-5*n^2=1
 - (m-2*n)^2-5*n^2=-1
 -}
import Data.List
mult [d,a, b] [_,a1, b1]=
    [d,a*a1+d*b*b1,a*b1+b*a1]
pow 1 x=x
pow n x =mult x $pow (n-1) x
    where
    mult [d,a, b] [_,a1, b1]=[d,a*a1+d*b*b1,a*b1+b*a1]
-- 2^2-5*1^2=-1
-- so [5,2,1]
fun =
    [d^2+c^2|
    a<-[1..20],
    let [_,b,c]=pow a [5,2,1],
    let d=2*c+b
    ]
-- 9^2-5*4^2=1
-- so [5,9,4]
fun2 =
    [d^2+c^2|
    a<-[1..20],
    let [_,b,c]=pow a [5,9,4],
    let d=2*c+b
    ]
problem_138 =sum$take 12 $nub$sort (fun++fun2)
