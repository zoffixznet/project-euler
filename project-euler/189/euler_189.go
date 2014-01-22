package main

/*

http://projecteuler.net/problem=189

*/

import (
    "fmt"
)

type ColorArray struct {
    n int32
    colors[2] int32
}

func CreateColorArray() ColorArray {
    return ColorArray{n:0, colors:[2]int32{0,0}}
}

/*
func (s * Square) Increment() {
    s.n++
    s.delta += 2
    s.value += s.delta
}

func CreateSquare(n int64) Square {
    return Square{n,n*n,n*2-1}
}

func (s * Square) Inc2() {
    s.Increment()
    s.Increment()
}

type SquareRange struct {
    bottom Square
    top Square
}

func (r SquareRange) SqDiff() int64 {
    return r.top.value - r.bottom.value
}

func (r SquareRange) Diff() int64 {
    return (r.top.n - r.bottom.n) / 2
}

*/
func main() {
    /*
    var this_range[2] SquareRange
    this_range[0] = SquareRange {CreateSquare(1), CreateSquare(3) }
    this_range[1] = SquareRange {CreateSquare(2), CreateSquare(4) }
    */

    const (
        num_colors int32 = 3
    )

    var colors[num_colors][num_colors] ColorArray;

    for i := int32(0); i < num_colors; i++ {
        for j := int32(0); j < num_colors; j++ {
            var arr = CreateColorArray()
            for c := int32(0); c < num_colors; c++ {
                if ((c != i) && (c != j)) {
                    arr.colors[arr.n] = c
                    arr.n++
                }
            }
            colors[i][j] = arr
        }
    }

    /*
    for ((next_range.Diff() >= 0) && (next_range.SqDiff() > max)) {

    var count int64 = 0
    // var occurences map[int64]int8
    occurences := make(map[int64]int8)
    var mod = 0
    var max int64 = 1000000
    for ((this_range[mod].Diff() > 0) && (this_range[mod].SqDiff() <= max)) {
        // count += (this_range[mod].Diff())
        {
            var iter_range SquareRange = this_range[mod]
            for (iter_range.Diff() > 0) {
                var n = iter_range.SqDiff()
                c, ok := occurences[n]
                if (ok) {
                    if (c != 11) {
                        if (c == 10) {
                            count--
                        }
                        occurences[n] = c+1
                    }
                } else {
                    count++;
                    occurences[n] = 1
                }
                iter_range.bottom.Inc2()
            }
        }

        var next_range SquareRange = this_range[mod]
        next_range.top.Inc2()

        // var prev_bottom Square = next_range.bottom

        // for (next_range.top.value - next_range.bottom.value > 1000000) {
        for ((next_range.Diff() >= 0) && (next_range.SqDiff() > max)) {
            next_range.bottom.Inc2()
        }

        this_range[mod] = next_range
        mod = 1 - mod
    }

    fmt.Println("count = ", count)
    */
}
