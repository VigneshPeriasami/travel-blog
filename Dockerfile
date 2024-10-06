FROM golang:1.20 AS web-server
LABEL stage=intermediate-build
WORKDIR /auth-server
COPY ./auth-server/go.* ./
RUN go mod download
COPY ./auth-server/ ./
RUN CGO_ENABLED=0 go build -o bin/server
CMD ["./bin/server"]
