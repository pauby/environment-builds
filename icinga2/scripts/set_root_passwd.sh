#!/bin/bash

#
# Sets the root password - handy for Vagrant boxes
#
# Usage:
#  Setup root password:  ./set_root_passwd.sh 'your_new_root_password'
#

# Delete package expect when script is done
# 0 - No; 
# 1 - Yes.
PURGE_EXPECT_WHEN_DONE=0

#
# Check input params
#
if [ -n "${1}" ]; then
    # Setup root password
    NEW_ROOT_PASSWORD="${1}"
else
    echo "Usage:"
    echo "  Setup root password: ${0} 'your_new_root_password'"
    exit 1
fi

#
# Check is expect package installed
#
if [ $(yum list installed expect 2>/dev/null | grep -c "expect.x86_64") -eq 0 ]; then
    echo "Can't find expect. Trying install it..."
    yum install expect -y -q
fi

SECURE_ROOT=$(expect -c "
set timeout 3
spawn passwd root
expect \"New password:\"
send \"$NEW_ROOT_PASSWORD\r\"
expect \"Retype new password:\"
send \"$NEW_ROOT_PASSWORD\r\"
expect eof
")

#
# Execution mysql_secure_installation
#
echo "${SECURE_ROOT}"

if [ "${PURGE_EXPECT_WHEN_DONE}" -eq 1 ]; then
    # Uninstalling expect package
    yum remove expect -y -q
fi

exit 0