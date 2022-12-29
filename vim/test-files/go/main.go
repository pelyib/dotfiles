package main

import (
	"fmt"
	"time"
)

func main() {
	fmt.Print("hello")
	second()
}

func second() {
	time.Now()
	fmt.Print("joj")
}
