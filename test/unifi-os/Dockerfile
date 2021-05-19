FROM docker.io/library/debian:latest

RUN apt-get update \
 && apt-get install --no-install-recommends -y ca-certificates curl init openssh-client \
 && rm -rf /var/lib/apt/lists/* \
 && printf '%s\n' '#!/bin/sh' 'exec ssh -p "$(cat /etc/unifi-os/ssh_proxy_port)" -o StrictHostKeyChecking=no -q root@localhost -- "$@"' \
  | tee /sbin/ssh-proxy \
 && chmod a+x /sbin/ssh-proxy

CMD ["/sbin/init"]
