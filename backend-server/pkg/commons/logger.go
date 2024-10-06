package commons

import (
	"log"
	"os"
)

func NewLogger() *log.Logger {
	return log.New(
		os.Stdout,
		"[backend-server]",
		log.Ldate|log.Ltime|log.Lmicroseconds|log.LUTC|log.Lshortfile,
	)
}
