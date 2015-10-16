package main

import (
  "fmt"
  "flag"
  "time"
)

const FLOAT_FORMAT string = "%1.23f"

type Result struct {
  method string
  iter int
  msg string
}

func multDouble(i int, c chan *Result) {
  mult := float64(i) * float64(0.1)
  r := Result{method: "double", iter:i, msg:fmt.Sprintf(FLOAT_FORMAT, mult)}
  c <- &r
}

func multSingle(i int, c chan *Result) {
  mult := float32(i) * float32(0.1)
  r := Result{method: "single", iter: i, msg: fmt.Sprintf(FLOAT_FORMAT, mult)}
  c <- &r
}

func sumSingle(i int, c chan *Result) float32 {
  sum := float32(0.0)
  if i > 0 {
    sum += float32(0.1) + sumSingle(i-1, c)
  }

  r := Result{method: "sum", iter: i, msg: fmt.Sprintf(FLOAT_FORMAT, sum) }
  c <- &r

  return sum
}

func printTable(max int, table []map[string]string, result chan *Result, done chan bool) {
  for {
    select {
    case rPtr, ok := <- result:
      if ok {
        r := *rPtr
        table[r.iter][r.method] = r.msg
        fmt.Println("\n", time.Now().String(), "\n")
        fmt.Printf("%3s %25s %25s %25s\n", "i", "sum", "float product", "double product")
        for i := 0; i < (max + 1); i ++ {
          fmt.Printf("%3d %25s %25s %25s\n", i, table[i]["sum"], table[i]["single"], table[i]["double"])
        }
        fmt.Println("\n")
        done <- true
      }
    }
  }
}

func main() {
  var maxPtr = flag.Int("max", 0, "Use floating point math to multiply 0.1 up to this number")
  flag.Parse()

  max := (*maxPtr)
  if max > 0 {
    // max is the highest iteration so
    // max is the highest index and
    // max + 1 is the capacity
    size := max + 1

    // init table
    table := make([]map[string]string, size)
    for i := 0; i < size; i++ {
      table[i] = make(map[string]string)
    }

    // channel to count completions
    done := make(chan bool)

    // init result channel and table printer
    result := make(chan *Result)
    go printTable(max, table, result, done)
    
    // Run go routines to calculate results
    go sumSingle(max, result)
    for i := 0; i < size; i++ {
      go multSingle(i, result)
      go multDouble(i, result)
    }

    // wait for all results to finish
    for i := 0; i < (size*3); i++ {
      <- done
    }
    close(done)
    close(result)
  }
}
