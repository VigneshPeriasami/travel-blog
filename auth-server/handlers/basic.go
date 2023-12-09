package handlers

import (
	"log"
	"net/http"

	"github.com/vigneshperiasami/auth-server/controller"
	"go.uber.org/fx"
)

type HttpAuthHandler interface {
	Home(http.ResponseWriter, *http.Request)
	Authenticate(http.ResponseWriter, *http.Request)
}

type HttpAuth struct {
	authController controller.AuthController
	logger         *log.Logger
}

func NewHttpAuthHandlers(authController controller.AuthController, logger *log.Logger) HttpAuthHandler {
	return &HttpAuth{authController, logger}
}

func (h *HttpAuth) Home(resp http.ResponseWriter, req *http.Request) {
	resp.Header().Set("Content-Type", "text/plain")
	resp.Write([]byte("Auth service"))
}

func (h *HttpAuth) Authenticate(resp http.ResponseWriter, req *http.Request) {
	user, pass, _ := req.BasicAuth()

	authUser, err := h.authController.Authenticate(user, pass)
	resp.Header().Set("Content-Type", "text/plain")
	if err != nil {
		resp.Header().Set("WWW-Authenticate", "Basic realm=\"auth app\"")
		resp.WriteHeader(http.StatusUnauthorized)
		return
	}

	h.logger.Printf("User login: %v (%v)", authUser.Username, authUser.Uuid)
	resp.WriteHeader(http.StatusOK)
	resp.Write([]byte("Success"))
}

var Module = fx.Options(
	fx.Provide(
		NewHttpAuthHandlers,
	),
)
