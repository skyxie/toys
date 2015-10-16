package main

import (
  "fmt"
  "flag"
  "time"
)

func PrintLog(start time.Time, x int, msg string) {
  var now = time.Now()
  var log = fmt.Sprintf("[%12s] %d!", now.Sub(start).String(), x)
  fmt.Println(log, msg)
}

func StreamLog(x int, logChan chan string, logDone chan int) {
  var start = time.Now()
  for {
    
    select {
    case msg, ok := <-logChan:
      if ok {
        PrintLog(start, x, msg)
      }
    case result, ok := <-logDone:
      if ok {
        PrintLog(start, x, fmt.Sprintf("= %d", result))
      }
    default:
      // noop
    }
  }
}

func Factorial(x int, logChan chan string) int {
  if x == 0 {
    logChan <- "end case 0! = 1"
    return 1
  } else {
    logChan <- fmt.Sprintf("recursively multiplying: %d * %d", x, x-1)
    return x * Factorial(x - 1, logChan)
  }
}

func main() {
  var max = flag.Int("max", 0, "Calculate factorial up to this number")

  done := make(chan bool)

  flag.Parse()

  for i := 0; i < *max; i++ {
    x := i
    
    logChan := make(chan string)
    logDone := make(chan int)
    go StreamLog(i, logChan, logDone)

    logChan <- "created"
    go func () {
      logDone <- Factorial(x, logChan)
      done <- true
      close(logChan)
      close(logDone)
    }()
  }

  for i := 0; i < *max; i++ {
    <- done
  }
  close(done)
}
