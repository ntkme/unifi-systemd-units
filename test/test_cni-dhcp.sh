#!/bin/sh

podman exec unifi-systemd systemctl start cni-dhcp.socket

podman exec unifi-systemd systemctl stop cni-dhcp.socket

podman exec unifi-systemd journalctl -u cni-dhcp.service
