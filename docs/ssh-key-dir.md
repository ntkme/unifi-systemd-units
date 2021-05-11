# ssh-key-dir

This service provides a directory `/mnt/data/.ssh/authorized_keys.d/` to persist your ssh public keys.

Any change made to public key files in `/mnt/data/.ssh/authorized_keys.d/` will be automatically synchronized to `/root/.ssh/authorized_keys`.

```
# unifi-systemd shell

bash-5.0# systemctl enable --now ssh-key-dir.service
Created symlink /etc/systemd/system/multi-user.target.wants/ssh-key-dir.service → /etc/systemd/system/ssh-key-dir.service.
```
