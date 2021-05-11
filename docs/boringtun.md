# container-boringtun

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
CONTAINER ID  IMAGE                    COMMAND  CREATED        STATUS            PORTS                     NAMES
cfe45bc18948  ghcr.io/ntkme/boringtun           5 seconds ago  Up 4 seconds ago  0.0.0.0:51820->51820/udp  boringtun-wg0

bash-5.0# podman exec boringtun-wg0 wg
interface: wg0
  public key: h1wFkpDYYYRAnLOW+At5+lGMY5FpUcxsK3X3qSimTkQ=
  private key: (hidden)
  listening port: 51820
```
