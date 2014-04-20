package main

/*

http://projecteuler.net/problem=174

[QUOTE]

We shall define a square lamina to be a square outline with a square "hole" so that the shape possesses vertical and horizontal symmetry.

Given eight tiles it is possible to form a lamina in only one way: 3x3 square with a 1x1 hole in the middle. However, using thirty-two tiles it is possible to form two distinct laminae.

If t represents the number of tiles used, we shall say that t = 8 is type L(1) and t = 32 is type L(2).

Let N(n) be the number of t ≤ 1000000 such that t is type L(n); for example, N(15) = 832.

What is ∑ N(n) for 1 ≤ n ≤ 10?

[/QUOTE]

*/

import (
    "fmt"
)

func main() {
    var f_n[10] int64
    var s_n[10] int64

    var i int
    for i = 1; i <= 9  ; i++ {
        f_n[i] = 0
        s_n[i] = 0
    }
    var digits[20] int
    for i = 0; i < 20  ; i++ {
        digits[i] = 0
    }


    var max_digit int = 0
    var n int64

    // 11 zeros
    var max_n int64
    max_n = 100000000000;

    var next_checkpoint int64 = 1000000;

    digits[0] = 0
    for n = 1; n < max_n ; n++ {
        if (n == next_checkpoint) {
            fmt.Println("Reached ", n)
            next_checkpoint += 1000000;
        }
        var p = 0
        for (digits[p] == 9) {
            digits[p] = 0
            p++
        }
        digits[p]++;
        if (p > max_digit) {
            max_digit = p
        }
        for p = 0 ; p <= max_digit; p++ {
            f_n[digits[p]]++
        }
        var d int
        for d = 1; d <= 9 ; d++ {
            if (f_n[d] == n) {
                s_n[d] += n
            }
        }
    }

    var sum int64
    sum = 0
    for n = 1; n <= 9  ; n++ {
        sum += s_n[n]
    }

    fmt.Println("Sum = ", sum)
}
