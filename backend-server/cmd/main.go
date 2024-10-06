package main

import (
	"context"
	"log"
	"net"
	"net/http"

	backend "github.com/vigneshperiasami/backend-server/pkg/server"
	"go.uber.org/fx"
)

func startServer(lc fx.Lifecycle, mux *http.ServeMux, log *log.Logger) {
	server := http.Server{Addr: ":8089", Handler: mux}
	lc.Append(fx.Hook{
		OnStart: func(ctx context.Context) error {
			ln, err := net.Listen("tcp", server.Addr)
			if err != nil {
				return err
			}
			log.Println("Starting server")
			go server.Serve(ln)
			return nil
		},

		OnStop: func(ctx context.Context) error {
			log.Println("Shutting down server")
			server.Shutdown(ctx)
			return nil
		},
	})
}

func main() {
	fx.New(backend.Module, fx.Invoke(startServer)).Run()
}
