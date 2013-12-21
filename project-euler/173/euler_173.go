package main

import (
    "fmt"
)

type Square struct {
    n int64
    value int64
    delta int64
}

func (s * Square) Increment() {
    s.n++
    s.delta += 2
    s.value += s.delta
}

func CreateSquare(n int64) Square {
    return Square{n,n*n,n*2-1}
}

func (s Square) Inc2() {
    s.Increment()
    s.Increment()
}

func main() {
    var s1 Square = CreateSquare(5)
    s1.Increment()
    fmt.Println("s1.n = ", s1.n, "\ns1.value = ", s1.value)
}
