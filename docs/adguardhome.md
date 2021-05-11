# container-adguardhome

This service provides [AdGuardHome](https://github.com/AdguardTeam/AdGuardHome).

To start this service, you need to create its data directory and condig directory.

- `/mnt/data/var/lib/adguardhome`
- `/mnt/data/etc/adguardhome`

You must specify the podman network name when starting the service.

```
# unifi-systemd shell

bash-5.1# mkdir -p /mnt/data/var/lib/adguardhome /mnt/data/etc/adguardhome

bash-5.1# podman network ls
NETWORK ID    NAME        VERSION  PLUGINS
2f259bab93aa  podman      0.4.0    bridge,portmap,firewall,tuning
fa2176b87e0e  bridge-br0  0.4.0    bridge,portmap,firewall,tuning

bash-5.1# systemctl enable --now container-adguardhome@bridge-br0.service
Created symlink /etc/systemd/system/multi-user.target.wants/container-adguardhome@bridge-br0.service → /etc/systemd/system/container-adguardhome@.service.

bash-5.1# podman ps
CONTAINER ID  IMAGE                                 COMMAND               CREATED        STATUS            PORTS  NAMES
533166ac9121  docker.io/adguard/adguardhome:latest  --no-check-update...  4 seconds ago  Up 4 seconds ago         adguardhome
```
