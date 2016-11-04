#!/bin/sh

# change sshd_config
if [ -f "/etc/ssh/sshd_config" ]; then
    sed -ri 's/^PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config \
    && sed -ri 's/^PasswordAuthentication\s+.*/PasswordAuthentication no/' /etc/ssh/sshd_config \
    && sed -ri 's/^HostKey\s+.*//g'
fi

# prepare run dir
if [ ! -d "/var/run/sshd" ]; then
    mkdir -p /var/run/sshd
fi

# prepare root ssh folder
if [ ! -d "/root/.ssh/" ]; then
    mkdir -p /root/.ssh/ && chmod 700 /root/.ssh/
fi

# prepare authorized_keys
if [ -d "/sshkey/" ]; then
    cp /sshkey/* /root/.ssh/ && chown root:root /root/.ssh/*
fi

if [ -f /root/.ssh/id_rsa]; then
    echo "HostKey /root/.ssh/id_rsa" >> /etc/ssh/sshd_config
else
    ssh-keygen -t rsa -N '' -f /etc/ssh/ssh_host_rsa_key \
    && echo "HostKey /etc/ssh/ssh_host_rsa_key" >> /etc/ssh/sshd_config
fi

exec "$@"
