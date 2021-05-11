# container-certbot{,-unifi}

These two services fetch and install free SSL/TLS certificates from [Let's Encrypt](https://letsencrypt.org/) using HTTP-01 challenge.

Because UDM always resolves the hostname `unifi` to itself, this service is opinionated to use `https://unifi.domain.name/` as controller address, with `domain.name` being the domain name configured for "LAN" Network.

- Edit "LAN" Network
  - Advanced
    - Domain Name: domain.name
- Add New Port Forwarding
  - Port: 80
  - Forward IP: 192.168.1.1
  - Forward Port: 8008
  - Protocol: TCP
- Add New Firewall Rule
  - Type: Internet Local
  - Rule Applied: After
  - Action: Accept
  - IPv4 Protocol: TCP
  - Destination
    - Destination Type: IP Address
    - IPv4 Address: 192.168.1.1
    - Port: 8008

```
# unifi-os restart

# unifi-systemd shell

bash-5.0# mkdir -p /mnt/data/etc/letsencrypt

bash-5.0# systemctl enable --now container-certbot{,-unifi}.service
Created symlink /etc/systemd/system/multi-user.target.wants/container-certbot.service → /etc/systemd/system/container-certbot.service.
Created symlink /etc/systemd/system/multi-user.target.wants/container-certbot-unifi.service → /etc/systemd/system/container-certbot-unifi.service.

bash-5.0# podman ps
CONTAINER ID  IMAGE                          COMMAND               CREATED        STATUS            PORTS  NAMES
296d16459e28  ghcr.io/ntkme/certbot          --http-01-port 80...  3 seconds ago  Up 2 seconds ago         certbot
4653cc5adcca  ghcr.io/ntkme/unifi-ssh-proxy  -c trap 'exit 0' ...  3 seconds ago  Up 2 seconds ago         certbot-unifi
```
