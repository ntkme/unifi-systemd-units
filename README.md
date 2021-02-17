# unifi-systemd-units

Systemd units for [unifi-systemd](https://github.com/ntkme/unifi-systemd) [container](https://github.com/ntkme/container-systemd-podman)

## Usage

#### Install `unifi-systemd`

Install [unifi-systemd](https://github.com/ntkme/unifi-systemd) and verify that it is running.

```
# unifi-systemd
Usage: /usr/sbin/unifi-systemd [status start stop reload restart shell]

# unifi-systemd status
unifi-systemd: running
```

#### Install `systemd` Units

Install systemd units from this repository to `/mnt/data/etc/systemd/system`.

``` sh
curl -fsSL https://github.com/ntkme/unifi-systemd-units/archive/main.tar.gz | tar -vxzC /mnt/data --strip-components 1 --exclude '*/*.md' --exclude '*/LICENSE' && unifi-systemd reload
```

#### Manage `systemd` Units

`unifi-systemd` is a container that runs `systemd` and nested `podman` containers.

Use `unifi-systemd shell` to enter the container shell to interact with `systemctl` and `podman`. 

To create a new container service unit, see [podman-generate-systemd(1)](https://docs.podman.io/en/latest/markdown/podman-generate-systemd.1.html).


## UniFi `systemd` Units

#### container-boringtun

This service provides WireGuard interfaces with [cloudflare/boringtun](https://github.com/cloudflare/boringtun).

To start this service, you need to create its config directory at `/mnt/data/etc/wireguard`. A template config will be created if config file for an interface is not found.

- Add New Firewall Rule
  - Type: Internet In
  - Rule Applied: After
  - Action: Accept
  - IPv4 Protocol: UDP
  - Destination
    - Destination Type: Address/Port Group
    - IPv4 Address Group: Any
    - Port Group: 51820

```
# unifi-systemd shell
bash-5.0# mkdir -p /mnt/data/etc/wireguard
bash-5.0# systemctl enable --now container-boringtun@wg0.service
Created symlink /etc/systemd/system/multi-user.target.wants/container-boringtun@wg0.service → /etc/systemd/system/container-boringtun@.service.
bash-5.0# podman ps
CONTAINER ID  IMAGE                           COMMAND               CREATED         STATUS             PORTS                     NAMES
cfe45bc18948  docker.io/ntkme/boringtun                             5 seconds ago   Up 4 seconds ago   0.0.0.0:51820->51820/udp  boringtun-wg0
```

#### container-caddy

This service provides [Caddy](https://caddyserver.com/) web server with automatic HTTPS.

Because port 80 and 443 are already used, Caddy must run on alternative ports and matching port forwarding and firewall rules must to be configured.

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

#### container-certbot{,-unifi}

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
# unifi-systemd restart
# unifi-systemd shell
bash-5.0# mkdir -p /mnt/data/etc/letsencrypt
bash-5.0# systemctl enable --now container-certbot{,-unifi}.service
Created symlink /etc/systemd/system/multi-user.target.wants/container-certbot.service → /etc/systemd/system/container-certbot.service.
Created symlink /etc/systemd/system/multi-user.target.wants/container-certbot-unifi.service → /etc/systemd/system/container-certbot-unifi.service.
bash-5.0# podman ps
CONTAINER ID  IMAGE                            COMMAND               CREATED         STATUS             PORTS                     NAMES
296d16459e28  docker.io/ntkme/certbot          --http-01-port 80...  3 seconds ago   Up 2 seconds ago                             certbot
4653cc5adcca  docker.io/ntkme/unifi-ssh-proxy  -c trap 'exit 0' ...  3 seconds ago   Up 2 seconds ago                             certbot-unifi
```

#### container-inadyn

This service provides an updated version of the built-in DDNS client [troglobit/inadyn](https://github.com/troglobit/inadyn).

To start this service, first create a config file at `/mnt/data/etc/inadyn/inadyn.conf`.

```
# unifi-systemd shell
bash-5.0# mkdir -p /mnt/data/etc/inadyn/ && touch /mnt/data/etc/inadyn/inadyn.conf
bash-5.0# systemctl enable --now container-inadyn.service
Created symlink /etc/systemd/system/multi-user.target.wants/container-inadyn.service → /etc/systemd/system/container-inadyn.service.
bash-5.0# podman ps
CONTAINER ID  IMAGE                           COMMAND               CREATED         STATUS                     PORTS                     NAMES
84d7a1c592ba  docker.io/troglobit/inadyn                            1 second ago    Up Less than a second ago                            inadyn
```

#### container-wpa\_supplicant

This services provides `wpa_supplicant`.

To start this service, put the config directory at `/mnt/data/etc/wpa_supplicant`. Make sure to use the correct interface when starting this service.

```
# unifi-systemd shell
bash-5.0# ls /mnt/data/etc/wpa_supplicant/wpa_supplicant.conf
/mnt/data/etc/wpa_supplicant/wpa_supplicant.conf
bash-5.0# systemctl enable --now container-wpa_supplicant@eth8.service
Created symlink /etc/systemd/system/multi-user.target.wants/container-wpa_supplicant@eth8.service → /etc/systemd/system/container-wpa_supplicant@.service.
bash-5.0# podman ps
CONTAINER ID  IMAGE                           COMMAND               CREATED        STATUS            PORTS                     NAMES
7618121be303  docker.io/ntkme/wpa_supplicant  -D wired -i eth8 ...  2 seconds ago  Up 2 seconds ago                            wpa_supplicant-eth8
```

#### ssh-key-dir

This service provides a directory `/mnt/data/.ssh/authorized_keys.d/` to persist your ssh public keys.

Any change made to public key files in `/mnt/data/.ssh/authorized_keys.d/` will be automatically synchronized to `/root/.ssh/authorized_keys`.

```
# unifi-systemd shell
bash-5.0# systemctl enable --now ssh-key-dir.service
Created symlink /etc/systemd/system/multi-user.target.wants/ssh-key-dir.service → /etc/systemd/system/ssh-key-dir.service.
```

#### unifi-entrypoint

This service provides a seamless migration for `udm-boot` and `unifi-entrypoint`. Existing scripts will continue to work on boot.

###### Migrating from `udm-boot`

To migrate from [udm-boot](https://github.com/boostchicken/udm-utilities), please install `unifi-systemd` and `unifi-systemd-units` first.

``` sh
podman exec unifi-os dpkg -P udm-boot
podman exec unifi-systemd systemctl enable unifi-entrypoint@mnt-data-on_boot.d.service
```

###### Migrating from `unifi-entrypoint`

To migrate from [unifi-entrypoint](https://github.com/ntkme/unifi-entrypoint), please install `unifi-systemd` and `unifi-systemd-units` first.

``` sh
podman exec unifi-os dpkg -P unifi-entrypoint
podman exec unifi-systemd systemctl enable unifi-entrypoint@mnt-data-entrypoint.d.service
```
