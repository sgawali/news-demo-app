FROM golang:1.23 AS base 


ENV NEWS_API_KEY="185b1826c80c483d90ca600eebd1128e"

WORKDIR /app
# We want to populate the module cache based on the go.{mod,sum} files.
COPY go.mod .
COPY go.sum .

RUN go mod download

COPY . .

# Build the Go app
RUN go build -o ./out/news-demo .

# Start fresh from a smaller distroless image
FROM gcr.io/distroless/base

COPY --from=base /app/out/news-demo /app/news-demo

COPY --from=base /app/assets ./assets

COPY --from=base /app/news ./news

COPY --from=base /app/index.html .

# This container exposes port 3000 to the outside world
EXPOSE 3000

# Run the binary program produced by `go install`
CMD ["/app/news-demo"]



