package main

/*

http://projecteuler.net/problem=189

*/

import (
    "fmt"
)

type ColorInt int32

type ColorArray struct {
    n ColorInt
    colors[2] ColorInt
}

func CreateColorArray() ColorArray {
    return ColorArray{n:0, colors:[2]ColorInt{0,0}}
}


const (
    num_colors ColorInt = 3
)

var colors[num_colors][num_colors] ColorArray
var l_colors[num_colors] ColorArray

type RowData struct {
    seq map[string]int
    derived map[string]map[string]int
    count int
}

func my_find(wanted_h int) int {

    var data = RowData{seq:make(map[string]int), derived:make(map[string]map[string]int), count:3}

    data.seq["0"] = 1
    data.seq["1"] = 1
    data.seq["2"] = 1

    {
        var deriv = make(map[string]int);
        deriv["0"] = 1
        deriv["1"] = 1
        deriv["2"] = 1
        data.derived[""] = deriv
    }

    return 0
}

func main() {
    /*
    var this_range[2] SquareRange
    this_range[0] = SquareRange {CreateSquare(1), CreateSquare(3) }
    this_range[1] = SquareRange {CreateSquare(2), CreateSquare(4) }
    */

    for i := ColorInt(0); i < num_colors; i++ {
        for j := ColorInt(0); j < num_colors; j++ {
            var arr = CreateColorArray()
            for c := ColorInt(0); c < num_colors; c++ {
                if ((c != i) && (c != j)) {
                    arr.colors[arr.n] = c
                    arr.n++
                }
            }
            colors[i][j] = arr
        }
    }

    for i := ColorInt(0); i < num_colors; i++ {
        var arr = CreateColorArray()
        for c := ColorInt(0); c < num_colors; c++ {
            if (c != i) {
                arr.colors[arr.n] = c
                arr.n++

            }
        }
        l_colors[i] = arr
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
