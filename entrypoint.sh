#!/bin/sh

#Exit on error
set -e

#first we create the users and groups we did set in our smb.conf
adduser -D -s /bin/false jayryz
addgroup tick
adduser -D -s /bin/false testuser1 
usermod -aG tick testuser1

#defining a function that takes the first arg given and then 
#gets the output of the file and sets the samba pass
set_samba_pass() {
    local user=$1
    local secret_file="/run/secrets/samba_pass_${user}"

    if [ -f "$secret_file" ]; then
        PASS=$(cat "$secret_file")
        #we use echo "2 times" here with newline because the smbpasswd expects 2 inputs
	echo -e "$PASS\n$PASS" | smbpasswd -a -s "$user"
        smbpasswd -e "$user"
    fi
}

set_samba_pass "jayryz"
set_samba_pass "testuser1"

mkdir -p /var/lib/samba/private /var/log/samba /var/run/samba /var/cache/samba
chown -R sambauser:sambashare /var/lib/samba /var/log/samba /var/run/samba /var/cache/samba
chmod -R 0755 /var/lib/samba /var/log/samba /var/run/samba /var/cache/samba
chmod 0700 /var/lib/samba/private

setfacl -m u:4000:rwx /share/samba/cash
setfacl -m g:4445:rwx /share/samba/cash
setfacl -d -m u:4000:rwx /share/samba/cash
setfacl -d -m g:4445:rwx /share/samba/cash
setfacl -m g:tick:rwx /share/samba/cash
setfacl -d -m g:tick:rwx /share/samba/cash

#start smbd via sambauser and trough gosu
exec gosu sambauser smbd --foreground --no-process-group
