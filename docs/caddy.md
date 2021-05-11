# container-caddy

This service provides [Caddy](https://caddyserver.com/) web server with automatic HTTPS.

Because port 80 and 443 are already used, Caddy must run on alternative ports with matching port forwarding and firewall rules configured.

- Add New Port Forwarding
  - Port: 80
  - Forward IP: 192.168.1.1
  - Forward Port: 2082
  - Protocol: TCP
- Add New Firewall Rule
  - Type: Internet Local
  - Rule Applied: After
  - Action: Accept
  - IPv4 Protocol: TCP
  - Destination
    - Destination Type: IP Address
    - IPv4 Address: 192.168.1.1
    - Port: 2082
- Add New Port Forwarding
  - Port: 443
  - Forward IP: 192.168.1.1
  - Forward Port: 2083
  - Protocol: TCP
- Add New Firewall Rule
  - Type: Internet Local
  - Rule Applied: After
  - Action: Accept
  - IPv4 Protocol: TCP
  - Destination
    - Destination Type: IP Address
    - IPv4 Address: 192.168.1.1
    - Port: 2083

```
# unifi-systemd shell
bash-5.0# mkdir -p /mnt/data/etc/caddy /mnt/data/var/lib/caddy
bash-5.0# cat /mnt/data/etc/caddy/Caddyfile
{
  http_port 2082
  https_port 2083
}

unifi.domain.name
bash-5.0# systemctl enable --now container-caddy.service
Created symlink /etc/systemd/system/multi-user.target.wants/container-caddy.service → /etc/systemd/system/container-caddy.service.
bash-5.0# podman ps
CONTAINER ID  IMAGE                             COMMAND               CREATED         STATUS             PORTS                     NAMES
7f6ac74c6e46  docker.io/library/caddy:2-alpine  caddy run --confi...  2 seconds ago   Up 2 seconds ago                             caddy
```

## container-caddy-unifi

This service installs caddy certificates to unifi controller.

Because UDM always resolves the hostname `unifi` to itself, this service is opinionated to use `https://unifi.domain.name/` as controller address, with `domain.name` being the domain name configured for "LAN" Network.

- Edit "LAN" Network
  - Advanced
    - Domain Name: domain.name

```
# unifi-os restart
# unifi-systemd shell
bash-5.0# systemctl enable --now container-caddy-unifi.service
Created symlink /etc/systemd/system/multi-user.target.wants/container-caddy-unifi.service → /etc/systemd/system/container-caddy-unifi.service.
```
