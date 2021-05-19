#!/bin/sh

podman exec unifi-systemd systemctl start cni-podman-bridge@eth0.service

podman exec unifi-systemd podman network inspect bridge-eth0

podman exec unifi-systemd systemctl stop cni-podman-bridge@eth0.service

podman exec unifi-systemd journalctl -u cni-podman-bridge@eth0.service
