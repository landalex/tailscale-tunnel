# Tailscale Tunnel

Like your own private ngrok/Cloudflare Tunnel. Connect to services over Tailscale, isolated in a Docker container and network (without privileged access) for security/convenience.

Create a Tailscale tunnel container configured to connect to some service running on another machine on your Tailscale network. Attach it to a Docker network (or the host network), and TCP traffic to the local container's specified port will be tunneled securely to the remove service via Tailscale. Use it to run a reverse proxy on a VPS that connects to the Raspberry Pi on your LAN, access services on different hosts on a Tailscale network via Docker/Docker Compose, or whatever else.

Based on [tailscale-docker](https://github.com/lpasselin/tailscale-docker).

# Usage

**Set the TAILSCALE_AUTH_KEY with your own ephemeral auth key**: <https://login.tailscale.com/admin/settings/keys>

## Quick

```bash
docker run -d 
    -e TUNNEL_NAME=tailscale-tunnel
    -e TAILSCALE_AUTH_KEY=your_auth_key_here
    -e LOCAL_PORT=8080
    -e SERVICE_HOSTNAME=service.tailnet-name.ts.net
    -e SERVICE_PORT=80
    -p 8080:8080
    --name tailscale-tunnel
    tailscale-tunnel
```

Access the tunnel via `tailscale-tunnel:8080`.

## As a reverse proxy to another machine on your Tailnet

1. Update the values in `.env_template` and rename it to `.env` 
1. Run `docker-compose up -d`
1. Go to `<SERVER_IP>:81` in your browser and log in to Nginx Proxy Manager
  - See [the docs](https://nginxproxymanager.com/guide/#quick-setup) for the default admin user credentials
1. Create a new Proxy Host or Stream using `TUNNEL_NAME` as the hostname and `LOCAL_PORT` as the port

## In an existing Docker network

1. Copy `.env_template`, update the values, and rename it to `.env`
1. Copy `docker-compose.yml` and remove everything except the `tailscale-tunnel` service
1. Add a network block to the bottom of the file:
```yaml
networks:
  default:
    external: true
    name: <DOCKER_NETWORK_NAME>
```
1. Run `docker-compose up -d`
1. Access the tunnel via `<TUNNEL_NAME>:<LOCAL_PORT>` on any other containers connected to the `<DOCKER_NETWORK_NAME>` network

## With an existing `docker-compose.yml`

1. Copy `.env_template`, update the values, and rename it to `.env` (or combine it with an existing `.env` file, if you're already using one)
1. Copy the `tailscale-tunnel` service into your existing `docker-compose.yml`
1. Access the tunnel via `<TUNNEL_NAME>:<LOCAL_PORT>` on any of the other containers in the `docker-compose.yml` file
  - All containers need to be on the same Docker network.


