#!/bin/sh

mkdir -p /mnt/data/etc/wireguard

( umask 077 && printf '%s\n' '[Interface]' 'Address = 10.8.0.1/24' 'PostUp = iptables --table nat --append POSTROUTING --jump MASQUERADE ' 'PostDown = iptables --table nat --delete POSTROUTING --jump MASQUERADE' 'ListenPort = 51820' 'PrivateKey = SJ5y5piShMk1OW34BfUrwh6duBPbV6NIngtJQvhFd34=' | tee /mnt/data/etc/wireguard/wg0.conf )

podman exec unifi-systemd systemctl start container-boringtun@wg0.service

sleep 1

podman exec unifi-systemd podman exec boringtun-wg0 wg

podman exec unifi-systemd podman logs boringtun-wg0

podman exec unifi-systemd systemctl stop container-boringtun@wg0.service

podman exec unifi-systemd journalctl -u container-boringtun@wg0.service
