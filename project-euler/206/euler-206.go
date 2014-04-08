package main

/*

http://projecteuler.net/problem=189

*/

import (
    "fmt"
    "math"
)

type MyInt int64

func my_recurse(d_suffix MyInt, prefix MyInt, l MyInt) {
    if (l == 8) {
        var n = prefix * 100000 + d_suffix;
        var sq = MyInt(math.Sqrt(float64(n)));
        if (sq * sq == n) {
            fmt.Printf("Result == %d ; Square == %d\n", sq, n);
        }
    } else {
        for d := MyInt(0); d < 10; d++ {
            my_recurse(d_suffix, d+10*(l+10*prefix), l+1);
        }
    }
}

func my_recurse_wrap(d1 MyInt) {
    my_recurse(900+1000*(d1+80), 0, 1);
    return;
}

func main() {

    my_recurse_wrap(0);
    my_recurse_wrap(4);
    my_recurse_wrap(8);
}
