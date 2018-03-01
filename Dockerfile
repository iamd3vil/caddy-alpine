FROM golang:1.9.0-alpine as builder

LABEL description='Caddy server built from source without EULA'
LABEL author='me@saratchandra.in'


WORKDIR /app

# Install git
RUN apk update && apk add git

# Fetch caddy and builds
RUN go get -u github.com/iamd3vil/caddy/... && \
  go get -u github.com/nicolasazrak/caddy-cache/... && \
  go get -u github.com/caddyserver/builds

# Build caddy
RUN cd $GOPATH/src/github.com/iamd3vil/caddy/caddy && \
  go run build.go -goos=linux -goarch=amd64 && \
  cp caddy /usr/local/bin/

FROM alpine:3.7

# Add ca-certificates
RUN apk --no-cache add ca-certificates

# Copy caddy binary from alpine
COPY --from=builder /usr/local/bin/caddy /usr/local/bin/

# Copy default Caddyfile
COPY Caddyfile /etc/Caddyfile

VOLUME /root/.caddy/:/app

ENV CADDYPATH=/app/

EXPOSE 80 443 2015

CMD ["/usr/local/bin/caddy", "-conf", "/etc/Caddyfile", "-agree", "-email", ""]