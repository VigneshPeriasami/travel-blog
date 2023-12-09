package controller

import (
	"database/sql"
	"fmt"
	"log"
	"os"

	_ "github.com/go-sql-driver/mysql"
	"go.uber.org/fx"
)

type DbConn string

func NewDbConn(logger *log.Logger) DbConn {
	connString := fmt.Sprintf(
		"%s:%s@tcp(%s:%s)/%s",
		os.Getenv("MYSQL_USER"), os.Getenv("MYSQL_PASSWORD"),
		os.Getenv("MYSQL_HOST"), os.Getenv("MYSQL_PORT"), os.Getenv("MYSQL_DATABASE"))

	return DbConn(connString)
}

type User struct {
	Uuid     string
	Username string
}

type AuthController struct {
	conn   DbConn
	logger *log.Logger
}

func NewAuthController(conn DbConn, logger *log.Logger) AuthController {
	return AuthController{conn: conn, logger: logger}
}

func (a *AuthController) queryCred(username, password string) (User, error) {
	db, err := sql.Open("mysql", string(a.conn))
	var user User

	if err != nil {
		return user, err
	}
	err = db.QueryRow(
		"select uuid, username from user_cred where username = ? and password = ?",
		username,
		password,
	).Scan(&user.Uuid, &user.Username)

	if err != nil {
		return user, err
	}
	return user, nil
}

func (a *AuthController) Authenticate(username, password string) (User, error) {
	return a.queryCred(username, password)
}

var Module = fx.Options(
	fx.Provide(
		NewDbConn,
		NewAuthController,
	),
)
