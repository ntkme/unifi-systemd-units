# container-wpa\_supplicant

This services provides [wpa\_supplicant](https://w1.fi/wpa_supplicant/).

To start this service, put the config directory at `/mnt/data/etc/wpa_supplicant`. Make sure to use the correct interface when starting this service.

```
# unifi-systemd shell

bash-5.0# ls /mnt/data/etc/wpa_supplicant/wpa_supplicant.conf
/mnt/data/etc/wpa_supplicant/wpa_supplicant.conf

bash-5.0# systemctl enable --now container-wpa_supplicant@eth8.service
Created symlink /etc/systemd/system/multi-user.target.wants/container-wpa_supplicant@eth8.service → /etc/systemd/system/container-wpa_supplicant@.service.

bash-5.0# podman ps
CONTAINER ID  IMAGE                         COMMAND               CREATED        STATUS            PORTS  NAMES
7618121be303  ghcr.io/ntkme/wpa_supplicant  -D wired -i eth8 ...  2 seconds ago  Up 2 seconds ago         wpa_supplicant-eth8
```
