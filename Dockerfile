FROM golang:1.18-alpine as build

ENV GO111MODULE=on \
    CGO_ENABLED=0 \
    GOOS=linux \
    GOARCH=amd64

WORKDIR /go/src

COPY . .
RUN go mod download
RUN go build -o app ./

FROM alpine

RUN apk add --no-cache tzdata

COPY --from=build /go/src/app /go/src/app


EXPOSE 8080

WORKDIR /go/src

CMD ["./app"]
