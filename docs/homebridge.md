# container-homebridge

This service provides [homebridge](https://github.com/homebridge/homebridge).

To start this service, you need to create its data directory.

- `/mnt/data/var/lib/homebridge`

You must specify the podman network name when starting the service.

```
# unifi-systemd shell

bash-5.1# mkdir -p /mnt/data/var/lib/homebridge

bash-5.1# podman network ls
NETWORK ID    NAME        VERSION  PLUGINS
2f259bab93aa  podman      0.4.0    bridge,portmap,firewall,tuning
fa2176b87e0e  bridge-br0  0.4.0    bridge,portmap,firewall,tuning

bash-5.1# systemctl enable --now container-homebridge@bridge-br0.service
Created symlink /etc/systemd/system/multi-user.target.wants/container-homebridge@bridge-br0.service → /etc/systemd/system/container-homebridge@.service.

bash-5.1# podman ps
CONTAINER ID  IMAGE                             COMMAND  CREATED             STATUS                 PORTS  NAMES
c31901a827cf  docker.io/oznu/homebridge:latest           About a minute ago  Up About a minute ago         homebridge
```
