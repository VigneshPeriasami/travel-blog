package handlers

import (
	"fmt"
	"log"
	"net/http"
	"strings"

	auth "github.com/abbot/go-http-auth"
)

type DigestAuth struct {
	logger *log.Logger
}

type DigestParams struct {
	Realm  string
	qop    string
	nonce  string
	opaque string
}

func (d *DigestParams) HeaderString() string {
	return fmt.Sprintf("Digest realm=%s,qop=\"%s\",nonce=\"%s\",opaque=\"%s\"", d.Realm, d.qop, d.nonce, d.opaque)
}

func Parse(authorize string) (DigestParams, error) {
	s := strings.SplitN(authorize, " ", 2)
	if len(s) != 2 || s[0] != "Digest" {
		return DigestParams{}, fmt.Errorf("Not authorized at all")
	}

	return DigestParams{}, nil
}

func NewDigestAuth(logger *log.Logger) DigestAuth {
	return DigestAuth{logger}
}

func (d *DigestAuth) Authorize(authorize string) error {
	s := strings.SplitN(authorize, " ", 2)
	if len(s) != 2 || s[0] != "Digest" {
		return fmt.Errorf("Not authorized at all")
	}

	d.logger.Printf("%v\n", auth.ParsePairs(s[1]))
	return fmt.Errorf("Not authorized")
}

func (d *DigestAuth) Authenticate(resp http.ResponseWriter, req *http.Request) {
	err := d.Authorize(req.Header.Get("Authorize"))
	if err == nil {
		d.logger.Println("Authorized")
	}

	params := DigestParams{
		Realm:  "Staging App",
		qop:    "auth,auth-int",
		nonce:  "hello there",
		opaque: "hello again",
	}
	resp.Header().Set("WWW-Authenticate", params.HeaderString())
	resp.WriteHeader(http.StatusUnauthorized)
}
