FROM golang:1.22 AS backend-server
WORKDIR /backend-server
COPY go.* .
RUN go mod download
COPY . .
RUN CGO_ENABLED=0 go build -o bin/server ./cmd

CMD ["./bin/server"]
