#!/bin/bash -eux

# Install cloud-config
if [ -f /tmp/vagrantfile-user-data ]; then
  mv /tmp/vagrantfile-user-data /var/lib/coreos-vagrant/vagrantfile-user-data
fi

# Install unit-files
cp /data/indiehosters/unit-files/* /etc/systemd/system
systemctl daemon-reload

# Pull relevant docker images
docker pull indiehosters/haproxy-confd
docker pull indiehosters/nginx

# Activate default domain
etcdctl set /services/default '{"app":"nginx", "hostname":"'$1'"}'

# Configure and start HAproxy
mkdir -p /data/server-wide/haproxy/approved-certs
systemctl enable haproxy.service
systemctl start  haproxy.service
