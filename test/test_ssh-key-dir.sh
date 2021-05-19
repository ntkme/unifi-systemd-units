#!/bin/sh

grep -qF "$(cat /mnt/data/ssh/id_rsa.pub)" /root/.ssh/authorized_keys

podman exec unifi-systemd systemctl start ssh-key-dir.service

grep -qF "$(cat /mnt/data/ssh/id_rsa.pub)" /root/.ssh/authorized_keys

ssh-keygen -t ecdsa -f /tmp/id_ecdsa -N ''

cp /tmp/id_ecdsa.pub /mnt/data/.ssh/authorized_keys.d

sleep 1

grep -qF "$(cat /mnt/data/ssh/id_rsa.pub)" /root/.ssh/authorized_keys

grep -qF "$(cat /tmp/id_ecdsa.pub)" /root/.ssh/authorized_keys

rm -f /mnt/data/.ssh/authorized_keys.d/id_ecdsa.pub

sleep 1

grep -qF "$(cat /mnt/data/ssh/id_rsa.pub)" /root/.ssh/authorized_keys

! grep -qF "$(cat /tmp/id_ecdsa.pub)" /root/.ssh/authorized_keys

rm -f /tmp/id_ecdsa /tmp/id_ecdsa.pub

podman exec unifi-systemd systemctl disable ssh-key-dir.service

podman exec unifi-systemd journalctl -u ssh-key-dir.service
