#!/bin/bash
source setting.conf
unset OS_SERVICE_TOKEN OS_SERVICE_ENDPOINT
export OS_TENANT_NAME=$SET_KEYSTONE_ADMIN
export OS_USERNAME=$SET_KEYSTONE_ADMIN
export OS_PASSWORD=$SET_KEYSTONE_ADMIN_PASS
export OS_AUTH_URL=$SET_KEYSTONE_AUTH_URL
