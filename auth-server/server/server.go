package server

import (
	"context"
	"log"
	"net"
	"net/http"

	"github.com/vigneshperiasami/auth-server/handlers"
	"go.uber.org/fx"
)

const PORT = ":8090"

func NewHttpServer(lc fx.Lifecycle, mux *http.ServeMux, logger *log.Logger) *http.Server {
	srv := &http.Server{Addr: PORT, Handler: mux}

	lc.Append(fx.Hook{
		OnStart: func(ctx context.Context) error {

			ln, err := net.Listen("tcp", srv.Addr)
			if err != nil {
				return err
			}
			logger.Println("Starting Auth server on port", srv.Addr)
			go srv.Serve(ln)
			return nil
		},
		OnStop: func(ctx context.Context) error {
			return srv.Shutdown(ctx)
		},
	})
	return srv
}

type HandlerLogger = func(http.HandlerFunc) http.HandlerFunc

func NewHandlerLogger(logger *log.Logger) HandlerLogger {
	return func(hf http.HandlerFunc) http.HandlerFunc {
		return func(w http.ResponseWriter, r *http.Request) {
			logger.Println(r.URL.Path, r.Method)
			hf(w, r)
		}
	}
}

func NewServeMux(authHandler handlers.HttpAuthHandler, l HandlerLogger) *http.ServeMux {
	mux := http.NewServeMux()
	mux.HandleFunc("/", l(authHandler.Home))
	mux.HandleFunc("/auth", l(authHandler.Authenticate))
	return mux
}

var Module = fx.Options(
	fx.Provide(
		NewHandlerLogger,
		NewServeMux,
		NewHttpServer,
	),
)
