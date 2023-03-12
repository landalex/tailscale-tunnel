#!/bin/ash
trap 'kill -TERM $PID' TERM INT

echo "Starting Tailscale daemon"
# -state=mem: will logout and remove ephemeral node from network immediately after ending.
tailscaled --tun=userspace-networking --state=${TAILSCALE_STATE_ARG} &
PID=$!

until tailscale up --authkey="${TAILSCALE_AUTH_KEY}" --hostname="${TAILSCALE_HOSTNAME}"; do
    sleep 0.1
done

tailscale status

echo "Starting socat"

socat tcp-l:${LOCAL_PORT},fork,reuseaddr tcp:${SERVICE_HOSTNAME}:${SERVICE_PORT} &

echo "Forwarding TCP traffic from :${LOCAL_PORT} to ${SERVICE_HOSTNAME}:${SERVICE_PORT} via Tailscale"

wait ${PID}
wait ${PID}