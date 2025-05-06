#!/bin/bash
subject="${subject:-Backup created}"
function usage {
    echo ""
    echo "Create a backup of the system configuration and send it via email"
    echo ""
    echo "usage: $programname --to string"
    echo ""
    echo "  --to        string      receiver address to send the backup to"
    echo "  --hostname  string      hostname of the router"
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

if [[ -z $hostname ]]; then
    usage
    die "Missing parameter --hostname"
elif [[ -z $to ]]; then
    usage
    die "Missing parameter --to"
fi

echo "Starting backup process..."
sysupgrade -c -k -v --create-backup backup.tgz
echo "Backup created: backup.tgz
Sending email to $to..."
echo -e "Backup from $hostname generated at $(date '+%Y-%m-%d %H:%M:%S')" | mutt -s "Backup from $host" -a /root/backup/backup.tar.gz -- $to
echo "Mail sent successfully."