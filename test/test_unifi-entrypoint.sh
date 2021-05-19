#!/bin/sh

mkdir -p /mnt/data/on_boot.d

tee /mnt/data/on_boot.d/00-hello-world.sh <<'EOF'
#!/bin/sh
echo Hello World | tee /tmp/hello-world
EOF

podman exec unifi-systemd systemctl enable unifi-entrypoint@mnt-data-on_boot.d.service

podman restart unifi-os

timeout 60 sh -c 'until test -f /tmp/hello-world; do sleep 1; done'

rm -f /tmp/hello-world

podman exec unifi-systemd systemctl disable unifi-entrypoint@mnt-data-on_boot.d.service

podman exec unifi-systemd journalctl -u unifi-entrypoint@mnt-data-on_boot.d.service
