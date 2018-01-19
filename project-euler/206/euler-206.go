package main

/*

http://projecteuler.net/problem=206

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
	"math"
)

type MyInt int64

func my_recurse(d_suffix MyInt, prefix MyInt, l MyInt) {
	if l == 8 {
		var n = prefix*100000 + d_suffix
		var sq = MyInt(math.Sqrt(float64(n)))
		if sq*sq == n {
			fmt.Printf("Result == %d ; Square == %d\n", sq, n)
		}
	} else {
		for d := MyInt(0); d < 10; d++ {
			my_recurse(d_suffix, d+10*(l+10*prefix), l+1)
		}
	}
}

func my_recurse_wrap(d1 MyInt) {
	my_recurse(900+1000*(d1+80), 0, 1)
	return
}

func main() {

	my_recurse_wrap(0)
	my_recurse_wrap(4)
	my_recurse_wrap(8)
}
