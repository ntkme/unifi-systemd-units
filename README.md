# unifi-systemd-units

Systemd units for [unifi-systemd](https://github.com/ntkme/unifi-systemd) [container](https://github.com/ntkme/container-systemd-podman)

## Usage

#### Install `unifi-systemd`

For UniFi Dream Machine firmware <1.10.0, pull the legacy container with the support for legacy kernel.

``` sh
if podman exec unifi-os dpkg --compare-versions "$(uname -r)" lt 4.19 2>/dev/null; then
  podman pull ghcr.io/ntkme/systemd-podman:legacy && podman tag ghcr.io/ntkme/systemd-podman:legacy ghcr.io/ntkme/systemd-podman:latest
fi
```

Install [unifi-systemd](https://github.com/ntkme/unifi-systemd).

``` sh
podman exec unifi-os sh -c "curl -fsSLo /tmp/unifi-systemd_1.0.0_all.deb https://github.com/ntkme/unifi-systemd/releases/download/v1.0.0/unifi-systemd_1.0.0_all.deb && dpkg -i /tmp/unifi-systemd_1.0.0_all.deb && rm /tmp/unifi-systemd_1.0.0_all.deb"
```

Verify unifi-systemd is running.

```
# unifi-systemd
Usage: /usr/sbin/unifi-systemd [status start stop reload restart shell]

# unifi-systemd status
unifi-systemd: running
```

#### Install `systemd` Units

Install systemd units from this repository to `/mnt/data/etc/systemd/system`.

``` sh
curl -fsSL https://github.com/ntkme/unifi-systemd-units/archive/main.tar.gz | tar -vxzC /mnt/data --strip-components 1 --exclude '*/docs' --exclude '*/*.md' --exclude '*/LICENSE' && unifi-systemd reload
```

#### Manage `systemd` Units

`unifi-systemd` is a container that runs `systemd` and nested `podman` containers.

Use `unifi-systemd shell` to enter the container shell to interact with `systemctl` and `podman`. 

See the links below for documentation of services provided by this repository.

- [container-adguardhome](docs/adguardhome.md)
- [container-boringtun](docs/boringtun.md)
- [container-caddy{,-unifi}](docs/caddy.md)
- [container-certbot{,-unifi}](docs/certbot.md)
- [container-homebridge](docs/homebridge.md)
- [container-inadyn](docs/inadyn.md)
- [container-wpa\_supplicant](docs/wpa_supplicant.md)
- [ssh-key-dir](docs/ssh-key-dir.md)

To create a new container service unit, see [podman-generate-systemd(1)](https://docs.podman.io/en/latest/markdown/podman-generate-systemd.1.html).

#### Migrating from `udm-boot`

To migrate from [udm-boot](https://github.com/boostchicken/udm-utilities), please install `unifi-systemd` and `unifi-systemd-units` first.

``` sh
podman exec unifi-os dpkg -P udm-boot
podman exec unifi-systemd systemctl enable unifi-entrypoint@mnt-data-on_boot.d.service
```
