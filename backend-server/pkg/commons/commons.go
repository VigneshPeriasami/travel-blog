package commons

import "go.uber.org/fx"

import "net/http"

type Route interface {
	http.Handler
	Route() string
}

var Module = fx.Options(
	fx.Provide(NewLogger),
)
