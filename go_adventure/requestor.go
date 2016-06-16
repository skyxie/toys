package main

import (
  // "net/http"
  "flag"
  "strings"
  "fmt"
)

func main() {
  urlStr := flag.String("urls", "", "Make requests to these urls")
  max := flag.Int("max", 1, "Max channels")

  flag.Parse()

  urls := strings.Split(*urlStr, ",")

  var i int
  for i = 0; i < len(urls); i++ {
    fmt.Printf("%s\n", urls[i])
  }
}