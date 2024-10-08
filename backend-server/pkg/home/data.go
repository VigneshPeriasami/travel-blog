package home

type Response struct {
	Message string   `json:"message"`
	Email   string   `json:"email"`
	Name    string   `json:"name"`
	Tables  []string `json:"tables"`
}
