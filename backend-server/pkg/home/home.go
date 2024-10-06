package home

import (
	"fmt"
	"net/http"

	"github.com/vigneshperiasami/backend-server/pkg/commons"
	"go.uber.org/fx"
)

type HomeRoute struct {
}

var _ commons.Route = (*HomeRoute)(nil)

func NewHomeRoute() commons.Route {
	return &HomeRoute{}
}

func (h *HomeRoute) ServeHTTP(w http.ResponseWriter, r *http.Request) {
	w.Header().Add("Content-Type", "text/plain")
	subject := r.Header.Get("X-Auth-Subject")
	email := r.Header.Get("X-Auth-Email")
	w.Write([]byte(fmt.Sprintf("Hello %s, email: %s", subject, email)))
}

func (h *HomeRoute) Route() string {
	return "/"
}

var Module = fx.Provide(
	fx.Annotate(NewHomeRoute, fx.ResultTags(`group:"routes"`)),
)
