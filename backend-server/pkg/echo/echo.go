package echo

import (
	"encoding/json"
	"fmt"
	"net/http"

	"github.com/vigneshperiasami/backend-server/pkg/commons"
	"go.uber.org/fx"
)

type Echo struct {
}

func NewEcho() commons.Route {
	return &Echo{}
}

func (e *Echo) ServeHTTP(w http.ResponseWriter, r *http.Request) {
	w.Header().Add("Content-Type", "application/json")
	resp := struct {
		Message string `json:"message_body"`
	}{
		Message: "Hello From somewhere!!!",
	}
	respBody, err := json.Marshal(resp)
	if err != nil {
		w.Write([]byte(fmt.Sprintf("Error: %s", err.Error())))
	}
	w.Write(respBody)
}

func (e *Echo) Route() string {
	return "/api/echo"
}

var Module = fx.Options(
	fx.Provide(fx.Annotate(NewEcho, fx.ResultTags(`group:"routes"`))),
)
