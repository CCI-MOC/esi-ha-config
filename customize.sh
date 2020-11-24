#!/bin/sh

set -e

mkdir -m 700 /root/.ssh
curl -o /root/.ssh/authorized_keys https://github.com/larsks.keys
chmod 600 /root/.ssh/authorized_keys

yum -y remove cloud-init

mkdir /etc/systemd/system/serial-getty@.service.d
cat > /etc/systemd/system/serial-getty@.service.d/override.conf <<'EOF'
[Service]
ExecStart=
ExecStart=-/sbin/agetty -o '-p -- \\u' --keep-baud 115200,38400,9600 --autologin root %I $TERM
EOF

(
cat <<EOF
auth sufficient pam_listfile.so item=tty sense=allow file=/etc/rootconsole onerr=fail apply=root
EOF
cat /etc/pam.d/login
) > /etc/pam.d/login.new

mv /etc/pam.d/login.new /etc/pam.d/login

cat > /etc/rootconsole <<EOF
/dev/ttyS0
EOF

yum -y install centos-release-openstack-ussuri
yum config-manager --set-enabled PowerTools
yum -y upgrade
yum -y install python3-heat-agent* python3-openstackclient openstack-selinux
