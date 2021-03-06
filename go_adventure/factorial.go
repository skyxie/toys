package main

import (
  "fmt"
  "flag"
  "time"
)

func printLog(start time.Time, x int, msg string) {
  var now time.Time = time.Now()
  var log string = fmt.Sprintf("[%12s] %d!", now.Sub(start).String(), x)
  fmt.Println(log, msg)
}

func streamLog(x int, logChan chan string, logDone chan int) {
  var start time.Time = time.Now()
  for {

    select {
    case msg, ok := <-logChan:
      if ok {
        printLog(start, x, msg)
      }
    case result, ok := <-logDone:
      if ok {
        printLog(start, x, fmt.Sprintf("= %d", result))
      }
    default:
      // noop
    }
  }
}

func factorial(x int, logChan chan string) int {
  if x == 0 {
    logChan <- "end case 0! = 1"
    return 1
  } else {
    logChan <- fmt.Sprintf("recursively multiplying: %d * %d", x, x-1)
    return x * factorial(x - 1, logChan)
  }
}

func main() {
  var max = flag.Int("max", 0, "Calculate factorial up to this number")

  var done chan bool = make(chan bool)

  flag.Parse()

  var i int

  for i = 0; i < *max; i++ {
    var x int = i

    var logChan chan string = make(chan string)
    var logDone chan int = make(chan int)
    go streamLog(i, logChan, logDone)

    logChan <- "created"
    go func () {
      logDone <- factorial(x, logChan)
      done <- true
      close(logChan)
      close(logDone)
    }()
  }

  for i = 0; i < *max; i++ {
    <- done
  }
  close(done)
}
