package main

import (
  "fmt"
  "flag"
)

func factorial(x int) int {
  if x == 0 {
    fmt.Println("RETURN END CASE: 0! = 1")
    return 1
  } else {
    fmt.Printf("MULTIPLYING: %d * %d\n", x, x-1)
    return x * factorial(x - 1)
  }
}

func main() {
  var max = flag.Int("max", 0, "Calculate factorial up to this number")

  done := make(chan bool)

  flag.Parse()

  for i := 0; i < *max; i++ {
    x := i
    fmt.Printf("GOROUTINE SOLVE %d!\n", x)
    go func () {
      fmt.Printf("SOLUTION: %d! = %d\n", x, factorial(x))
      done <- true
    }()
  }

  for i := 0; i < *max; i++ {
    <- done
  }
}
