package main

/*

http://projecteuler.net/problem=156

=head1 COPYRIGHT & LICENSE

Copyright 2017 by Shlomi Fish

This program is distributed under the MIT / Expat License:
L<http://www.opensource.org/licenses/mit-license.php>

Permission is hereby granted, free of charge, to any person
obtaining a copy of this software and associated documentation
files (the "Software"), to deal in the Software without
restriction, including without limitation the rights to use,
copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following
conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.
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
