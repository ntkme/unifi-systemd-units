#!/bin/sh

mkdir -p /mnt/data/etc/wireguard

podman exec unifi-systemd systemctl start container-boringtun@wg0.service

sleep 1

podman exec unifi-systemd podman exec boringtun-wg0 wg

podman exec unifi-systemd podman logs boringtun-wg0

podman exec unifi-systemd systemctl stop container-boringtun@wg0.service

podman exec unifi-systemd journalctl -u container-boringtun@wg0.service
