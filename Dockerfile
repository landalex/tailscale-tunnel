FROM tailscale/tailscale:stable

RUN apk -U --no-cache upgrade \
    && apk --no-cache add socat
    
COPY start.sh /usr/bin/start.sh
RUN chmod +x /usr/bin/start.sh
CMD "start.sh"
