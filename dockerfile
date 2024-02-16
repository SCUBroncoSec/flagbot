# syntax=docker/dockerfile:1

# Build stage
FROM golang:1.22 AS build

# Set build dest
WORKDIR /build

# Set up dependencies
COPY go.mod go.sum ./
RUN go mod download

# Copy source
COPY *.go ./

# Build
RUN CGO_ENABLED=0 GOOS=linux go build -o /flagbot

# Release stage
FROM gcr.io/distroless/base-debian12 as release

WORKDIR /

# Copy binary and config
COPY --from=build /flagbot /flagbot
COPY /config /config

USER nonroot:nonroot

ENV TOKEN=""

ENTRYPOINT /flagbot -t ${TOKEN} -c /config
