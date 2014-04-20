package main

/*

http://projecteuler.net/problem=189

*/

import (
    "fmt"
    "strconv"
    "strings"
)

type ColorInt int32

type ColorArray struct {
    n ColorInt
    colors[2] ColorInt
}

func GetLastDigit(s string) ColorInt {
    var ret, _ = strconv.ParseInt(s[(len(s)-1):len(s)], 10, 32)
    return ColorInt(ret)
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

    for h := 1 ; h <= wanted_h-1; h++ {
        var this_seqs map[string]int = data.seq
        var prev_deriveds map[string]map[string]int = data.derived

        var next_data = RowData{seq:make(map[string]int), derived:make(map[string]map[string]int), count:0}

        for seq, seq_count := range this_seqs {
            for left, left_count := range (prev_deriveds[seq[0:len(seq)-1]]) {
                var delta int = seq_count * left_count
                var lefter_a ColorArray = colors[GetLastDigit(seq)][GetLastDigit(left)]
                for ler_idx := ColorInt(0) ; ler_idx < lefter_a.n ; ler_idx++ {
                    var lefter_tri_color = lefter_a.colors[ler_idx]
                    var leftest_a = l_colors[lefter_tri_color]

                    for lest_idx := ColorInt(0) ; lest_idx < leftest_a.n ; lest_idx++ {
                        var leftest_color = leftest_a.colors[lest_idx]
                        var str = strings.Join([]string{left, strconv.FormatInt(int64(leftest_color), 10)}, "")

                        next_data.count += delta
                        next_data.seq[str] += delta
                        _, ok := next_data.derived[seq]
                        if (! ok) {
                            next_data.derived[seq] = make(map[string]int)
                        }
                        next_data.derived[seq][str] += left_count
                    }
                }
            }
        }

        data = next_data
        fmt.Printf("Count[%d] = %d\n", h+1, data.count)
    }

    return data.count
}

func main() {

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
    {
        fmt.Printf("%d should be 3*2*2*2 == 24\n", my_find(2))
    }
    fmt.Printf("Result[8] = %d\n", my_find(8))

}
