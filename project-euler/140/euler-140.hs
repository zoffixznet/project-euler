
{-
                                      2
                                   3 x  + x
                            agx= ------------
                                    2
                                 - x  - x + 1
--->
                                   2             2
                                5 n  + 14 n + 1=d

--->                          k = 10 n + 14
--->                          20*d^2=k^2-176
--->                          k = 5 n + 2
--->                          5*d^2=k^2-44
-}
import Data.List
findmin d =
    d:head [[n,m]|
    m<-[1..10],
    n<-[1..10],
    n*n==d*m*m+1
    ]
findmin_s d =
    d:head [[n,m]|
    m<-[1..10],
    n<-[1..10],
    n*n==d*m*m+1
    ]
findmu d y=
    d:head [[n,m]|
    m<-[1..10],
    n<-[1..10],
    n*n==d+y*m
    ]
mux2 [d,a, b]=[d,a,-b]
mult [d,a, b] [_,a1, b1]=[d,a*a1+d*b*b1,a*b1+b*a1]
div2 [d,a, b] =[d,a`div`2,b`div`2]
pow 1 x=x
pow n x =mult x $pow (n-1) x
fun =
    [c|
    a<-[1..20],
    [_,b,_]<-powmu a,
    let bb=abs b,
    bb`mod`5==2,
    let c=bb`div`5
    ]
fun2=
    [c|
    a<-[1..20],
    [_,b,_]<-powmu1 a ,
    let bb=(abs b)*2,
    bb`mod`5==2,
    let c=bb`div`5
    ]
powmu n =
    [a,b,a1,a2,b1,b2]
    where
    c=pow n $findmin 5
    x1=findmu 5 44
    x2=mux2 x1
    a=mult c x1
    b=mult c x2
    a1=div2$mult a [5,3, -1]
    a2=div2$mult a [5,3, 1]
    b1=div2$mult b [5,3, -1]
    b2=div2$mult b [5,3, 1]
powmu1 n =
    [a,b]
    where
    c=pow n $findmin_s 5
    x1=findmu 5 11
    x2=mux2 x1
    a=mult c x1
    b=mult c x2
problem_140 =sum $take 30 [a-1|a<-nub$sort (fun++fun2)]

