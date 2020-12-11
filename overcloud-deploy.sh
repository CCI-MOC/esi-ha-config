#!/bin/sh

if [[ -z $OS_AUTH_URL ]]; then
	echo "ERROR: no credentials in environemnt. Did you remember to source stackrc?" >&2
	exit 1
fi

if [ -d templates ]; then
	TEMPLATES=$PWD/templates
else
	TEMPLATES=/usr/share/openstack-tripleo-heat-templates
fi

openstack overcloud deploy \
  --disable-validations \
  --templates $TEMPLATES \
  \
  --overcloud-ssh-user stack \
  \
  -e $TEMPLATES/environments/deployed-server-environment.yaml \
  -e deployedserverportmap.yml \
  -e hostnamemap.yml \
  -e settings.yml \
  "$@"
