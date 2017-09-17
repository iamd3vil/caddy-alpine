FROM golang:1.9.0-alpine as builder

LABEL description='Caddy server built from source without EULA'
LABEL author='me@saratchandra.in'


WORKDIR /app

# Install git
RUN apk update && apk add git

# Fetch caddy and builds
RUN go get -u github.com/mholt/caddy && \
  go get -u github.com/caddyserver/builds

# Build caddy
RUN cd $GOPATH/src/github.com/mholt/caddy/caddy && \
  go run build.go -goos=linux -goarch=amd64 && \
  cp caddy /usr/local/bin/

FROM alpine:3.6

# Add ca-certificates
RUN apk --no-cache add ca-certificates

# Copy caddy binary from alpine
COPY --from=builder /usr/local/bin/caddy /usr/local/bin/

# Copy default Caddyfile
COPY Caddyfile /etc/Caddyfile

VOLUME /root/.caddy/:/app/.caddy/

EXPOSE 80 443 2015

CMD ["/usr/local/bin/caddy", "-conf", "/etc/Caddyfile", "-agree", "-email", ""]