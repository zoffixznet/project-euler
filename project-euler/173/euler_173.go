package main

/*

http://projecteuler.net/problem=173

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

type Square struct {
	n     int64
	value int64
	delta int64
}

func (s *Square) Increment() {
	s.n++
	s.delta += 2
	s.value += s.delta
}

func CreateSquare(n int64) Square {
	return Square{n, n * n, n*2 - 1}
}

func (s *Square) Inc2() {
	s.Increment()
	s.Increment()
}

type SquareRange struct {
	bottom Square
	top    Square
}

func (r SquareRange) SqDiff() int64 {
	return r.top.value - r.bottom.value
}

func (r SquareRange) Diff() int64 {
	return (r.top.n - r.bottom.n) / 2
}

func main() {
	var this_range [2]SquareRange
	this_range[0] = SquareRange{CreateSquare(1), CreateSquare(3)}
	this_range[1] = SquareRange{CreateSquare(2), CreateSquare(4)}

	var count int64 = 0
	var mod = 0
	var max int64 = 1000000
	for (this_range[mod].Diff() > 0) && (this_range[mod].SqDiff() <= max) {
		count += (this_range[mod].Diff())
		var next_range SquareRange = this_range[mod]
		next_range.top.Inc2()

		// var prev_bottom Square = next_range.bottom

		// for (next_range.top.value - next_range.bottom.value > 1000000) {
		for (next_range.Diff() >= 0) && (next_range.SqDiff() > max) {
			next_range.bottom.Inc2()
		}

		this_range[mod] = next_range
		mod = 1 - mod
	}

	fmt.Println("count = ", count)
}
