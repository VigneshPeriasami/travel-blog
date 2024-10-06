package server

import (
	"log"
	"net/http"

	"github.com/vigneshperiasami/backend-server/pkg/commons"
	"github.com/vigneshperiasami/backend-server/pkg/echo"
	"github.com/vigneshperiasami/backend-server/pkg/home"
	"go.uber.org/fx"
)

type LogWrapper struct {
	logger *log.Logger
}

func NewLogWrapper(logger *log.Logger) *LogWrapper {
	return &LogWrapper{
		logger: logger,
	}
}

func (l *LogWrapper) Wrap(handler http.HandlerFunc) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		l.logger.Printf("[%s] - %s", r.Method, r.URL.Path)
		handler(w, r)
	}
}

func NewServerMux(routes []commons.Route, log *LogWrapper) *http.ServeMux {
	mux := http.NewServeMux()

	for _, r := range routes {
		mux.HandleFunc(r.Route(), log.Wrap(r.ServeHTTP))
	}

	return mux
}

var Module = fx.Options(
	commons.Module,
	home.Module,
	echo.Module,
	fx.Provide(NewLogWrapper),
	fx.Provide(fx.Annotate(NewServerMux, fx.ParamTags(`group:"routes"`))),
)
