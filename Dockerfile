## Build
# FROM golang:1.12 AS builder
FROM golang:1.18.9-alpine AS builder

WORKDIR /usr/src/app

# pre-copy/cache go.mod for pre-downloading 
# dependencies and only redownloading 
# them in subsequent builds if they change
COPY go.* ./
RUN go mod download && go mod verify

COPY . .
# RUN go build -v -o danilogo
RUN go build -v -o /usr/local/bin/app ./...

## Deploy
# Create a new release build stage
# FROM gcr.io/distroless/base-debian10
# FROM alpine:3.9 
FROM scratch 

WORKDIR /

# Copy over the binary built from the previous stage
COPY --from=builder /usr/local/bin/app /hello_go_http

# CMD ["app"]
ENTRYPOINT ["/hello_go_http"]