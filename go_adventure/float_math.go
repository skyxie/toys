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

func multDouble(i int, c chan Result) {
  var mult float64 = float64(i) * float64(0.1)
  var r Result = Result{method: "double", iter:i, msg:fmt.Sprintf(FLOAT_FORMAT, mult)}
  c <- r
}

func multSingle(i int, c chan Result) {
  var mult float32 = float32(i) * float32(0.1)
  var r Result = Result{method: "single", iter: i, msg: fmt.Sprintf(FLOAT_FORMAT, mult)}
  c <- r
}

func sumSingle(i int, c chan Result) float32 {
  var sum float32 = 0.0
  if i > 0 {
    sum += float32(0.1) + sumSingle(i-1, c)
  }

  var r Result = Result{method: "sum", iter: i, msg: fmt.Sprintf(FLOAT_FORMAT, sum) }
  c <- r

  return sum
}

func printTable(max int, table []map[string]string, result chan Result, done chan bool) {
  var start time.Time = time.Now()
  for r := range result {
    var event_time time.Time = time.Now()
    var dur time.Duration = event_time.Sub(start)
    table[r.iter][r.method] = r.msg
    fmt.Println("\n", dur.String(), "\n")
    fmt.Printf("%3s %25s %25s %25s\n", "i", "sum", "float product", "double product")
    for i, row := range table {
      fmt.Printf("%3d %25s %25s %25s\n", i, row["sum"], row["single"], row["double"])
    }
    fmt.Println("\n")
    done <- true
  }
}

func main() {
  var maxPtr = flag.Int("max", 0, "Use floating point math to multiply 0.1 up to this number")
  flag.Parse()

  var max int = (*maxPtr)
  if max > 0 {
    // max is the highest iteration so
    // max is the highest index and
    // max + 1 is the capacity
    var size int = max + 1

    // array index - we'll be using this guy a lot
    var i int

    // init table
    var table []map[string]string = make([]map[string]string, size)
    for i = 0; i < size; i++ {
      table[i] = make(map[string]string)
    }

    // channel to count completions
    var done chan bool = make(chan bool)

    // init result channel and table printer
    var result chan Result = make(chan Result)
    go printTable(max, table, result, done)

    // Run go routines to calculate results
    go sumSingle(max, result)
    for i = 0; i < size; i++ {
      go multSingle(i, result)
      go multDouble(i, result)
    }

    // wait for all results to finish
    for i = 0; i < (size*3); i++ {
      <- done
    }
    close(done)
    close(result)
  }
}
