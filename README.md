# Caddy-Alpine

Builds caddy from source and runs it in a Alpine image.

Since it builds from source, EULA doesn't apply for this docker image.

Uses multistage builds to minimize the size of the image.

# Caddyfile

`caddy-alpine` is configured to get the Caddyfile from `/etc/Caddyfile`. We can mount a volume from host to `/etc/Caddyfile` to supply your own Caddyfile.

# Saving certicates

Certificates are always stored inside the image at `/app`. So we can make a volume so that certs are not generated everytime we start since Let's Encrypt is rate limited.

# Example

```bash
docker run -p 80:80 -p 443:443 \
    -v /etc/Caddyfile:/etc/Caddyfile \
    -v /root/.caddy/:/app \
    iamd3vil/caddy-alpine
```
