# container-inadyn

This service provides an updated version of the built-in DDNS client [troglobit/inadyn](https://github.com/troglobit/inadyn).

To start this service, first create a config file at `/mnt/data/etc/inadyn/inadyn.conf`.

```
# unifi-systemd shell

bash-5.0# mkdir -p /mnt/data/etc/inadyn/ && touch /mnt/data/etc/inadyn/inadyn.conf

bash-5.0# systemctl enable --now container-inadyn.service
Created symlink /etc/systemd/system/multi-user.target.wants/container-inadyn.service → /etc/systemd/system/container-inadyn.service.

bash-5.0# podman ps
CONTAINER ID  IMAGE                       COMMAND  CREATED         STATUS                     PORTS  NAMES
84d7a1c592ba  docker.io/troglobit/inadyn           1 second ago    Up Less than a second ago         inadyn
```
