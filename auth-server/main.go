package main

import (
	"log"
	"net/http"
	"os"

	_ "github.com/go-sql-driver/mysql"
	"github.com/joho/godotenv"
	"github.com/vigneshperiasami/auth-server/controller"
	"github.com/vigneshperiasami/auth-server/handlers"
	"github.com/vigneshperiasami/auth-server/server"
	"go.uber.org/fx"
)

func NewLogger() *log.Logger {
	return log.New(
		os.Stdout,
		"[AuthServer] ",
		log.Ldate|log.Ltime|log.Lmicroseconds|log.LUTC|log.Lshortfile,
	)
}

func main() {
	godotenv.Load("../.env")

	fx.New(
		handlers.Module,
		controller.Module,
		fx.Provide(NewLogger),
		server.Module,
		fx.Invoke(func(httpSrv *http.Server) {}),
	).Run()
}
