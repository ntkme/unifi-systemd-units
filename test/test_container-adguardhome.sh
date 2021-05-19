#!/bin/sh

mkdir -p /mnt/data/var/lib/adguardhome /mnt/data/etc/adguardhome

podman exec unifi-systemd systemctl start container-adguardhome@host.service

timeout 60 sh -c 'until curl -fsSL http://127.0.0.1:3000/; do sleep 1; done'

podman exec unifi-systemd podman logs adguardhome-host

podman exec unifi-systemd systemctl stop container-adguardhome@host.service

podman exec unifi-systemd journalctl -u container-adguardhome@host.service
