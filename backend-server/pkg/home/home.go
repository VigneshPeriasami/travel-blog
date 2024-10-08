package home

import (
	"encoding/json"
	"fmt"
	"net/http"

	"github.com/vigneshperiasami/backend-server/pkg/commons"
	"go.uber.org/fx"
)

type HomeRoute struct {
	repo *Repo
}

var _ commons.Route = (*HomeRoute)(nil)

func NewHomeRoute(repo *Repo) commons.Route {
	return &HomeRoute{repo: repo}
}

func (h *HomeRoute) ServeHTTP(w http.ResponseWriter, r *http.Request) {
	w.Header().Add("Content-Type", "application/json")
	subject := r.Header.Get("X-Auth-Subject")
	email := r.Header.Get("X-Auth-Email")
	h.repo.insertPrimaryUser()
	tables, err := h.repo.readAllTables()
	if err != nil {
		w.Write([]byte(fmt.Sprintf("Error: %s", err)))
		return
	}

	response, _ := json.Marshal(Response{
		Message: "Hello there, added new entry!!",
		Name:    subject,
		Email:   email,
		Tables:  tables,
	})
	w.Write([]byte(response))
}

func (h *HomeRoute) Route() string {
	return "/"
}

var Module = fx.Options(
	fx.Provide(NewRepo),
	fx.Provide(
		fx.Annotate(NewHomeRoute, fx.ResultTags(`group:"routes"`)),
	),
)
