#!/bin/bash

if [[ -z $ADMIN_PASSWORD ]]; then
	ADMIN_PASSWORD=$(cat /dev/urandom | base64 | tr -dc "a-zA-Z1-9" | fold -w 16 | head -n 1)
	echo "################################################################"
	echo "########## GENERATED ADMIN PASSWORD: $ADMIN_PASSWORD ##########"
	echo "################################################################"
else
	echo "################################################################"
	echo "########### Using user defined admin password. #################"
	echo "################################################################"
fi
asadmin start-domain -d
echo "AS_ADMIN_PASSWORD=">/tmp/pwd.txt
echo "AS_ADMIN_NEWPASSWORD=${ADMIN_PASSWORD}">>/tmp/pwd.txt
asadmin --host localhost --port 4848 --user admin --passwordfile /tmp/pwd.txt change-admin-password
echo "AS_ADMIN_PASSWORD=${ADMIN_PASSWORD}">/tmp/pwd.txt
asadmin --host localhost --port 4848 --user admin --passwordfile /tmp/pwd.txt enable-secure-admin
asadmin --host localhost --port 4848 --user admin --passwordfile /tmp/pwd.txt set configs.config.default-config.admin-service.jmx-connector.system.address=127.0.0.1
asadmin --host localhost --port 4848 --user admin --passwordfile /tmp/pwd.txt set configs.config.default-config.admin-service.jmx-connector.system.security-enabled=false
rm -f /tmp/pwd.txt
asadmin stop-domain

exec "$@"
