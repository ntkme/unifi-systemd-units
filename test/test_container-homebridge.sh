#!/bin/sh

mkdir -p /mnt/data/var/lib/homebridge

podman exec unifi-systemd systemctl start container-homebridge@host.service

timeout 60 sh -c 'until curl -fsSL http://127.0.0.1:8581/; do sleep 1; done'

podman exec unifi-systemd podman logs homebridge-host

podman exec unifi-systemd systemctl stop container-homebridge@host.service

podman exec unifi-systemd journalctl -u container-homebridge@host.service
