#!/bin/bash
opkg update
opkg install msmtp mutt

port="${port:-465}"
tls="${tls:-on}"
tls_starttls="${tls_starttls:-off}"
set_from_header="${set_from_header:-on}"
allow_from_override="${allow_from_override:-off}"
syslog="${syslog:-LOG_MAIL}"
programname=$(basename "$0")
hostname="${hostname:-example.com}"
realname="${realname:-OpewnWrt Backup}"
frequency="${frequency:-@daily}"

function usage {
    echo ""
    echo "Setup msmtp configuration file"
    echo ""
    echo "usage: $programname --host_name string --from from_address --user username --password password "
    echo ""
    echo "  --hostname          string      host name of the SMTP server"
    echo "                          (example: example.com)"
    echo "  --from              string      from address to use"
    echo "                          (example: address@example.com)"
    echo "  --user              string  username to use for authentication"
    echo "                          (example: username)"
    echo "  --password          string  password to use for authentication"
    echo "                          (example: password)"
    echo "  --to                string      target email"
    echo "                          (example: target@example.com)"    
    echo "  --system_hostname   string      target email"
    echo "                          (example: target@example.com)"    
    echo ""
}

function die {
    printf "Script failed: %s\n\n" "$1"
    exit 1
}


while [ $# -gt 0 ]; do
    if [[ $1 == "--help" ]]; then
        usage
        exit 0
    elif [[ $1 == "--"* ]]; then
        echo "Processing $1 $2 $3"
        v="${1/--/}"
        declare "$v"="$2"
        shift
    fi
    shift
done

echo hostname: $hostname


if [[ -z $hostname ]]; then
    usage
    die "Missing parameter --hostname"
elif [[ -z $from ]]; then
    usage
    die "Missing parameter --from"
elif [[ -z $user ]]; then
    usage
    die "Missing parameter --user"
elif [[ -z $password ]]; then
    usage
    die "Missing parameter --password"
elif [[ -z $to ]]; then
    usage
    die "Missing parameter --to"    
elif [[ -z $system_hostname ]]; then
    usage
    die "Missing parameter --system_hostname"    
fi


echo "# Example for a system wide configuration file

# A system wide configuration file is optional.
# If it exists, it usually defines a default account.
# This allows msmtp to be used like /usr/sbin/sendmail.
account default

# The SMTP smarthost
host $hostname

# Use TLS on port 465. On this port, TLS starts without STARTTLS.
port 465
tls on
tls_starttls off

# Construct envelope-from addresses of the form "user@oursite.example"
from $from
# Do not allow programs to override this envelope-from address via -f
allow_from_override off
# Always set a From header that matches the envelope-from address
set_from_header on

# Syslog logging with facility LOG_MAIL instead of the default LOG_USER
syslog LOG_MAIL

auth on
user $user
password $password" > /etc/msmtprc

echo "
set sendmail="/usr/bin/msmtp"
set use_from=yes
set realname="$from"
set from=$from
set envelope_from=yes
" > /root/.muttrc

currentdir=$(pwd)
echo "$frequency $currentdir/backup.sh --to $to --hostname $system_hostname" >> /etc/crontabs/root
service cron restart