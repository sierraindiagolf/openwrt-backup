# Auto backup for OpenWRT and send the backup via email
## Installation
Install `bash`
~~~
opkg update
opkg install bash
~~~

Clone this repository on your target device.
~~~
git clone https://github.com/sierraindiagolf/openwrt-backup.git
~~~

Download via wget
~~~
wget -O backup.sh https://raw.githubusercontent.com/sierraindiagolf/openwrt-backup/refs/heads/mai
n/backup.sh
wget -O setup.sh https://raw.githubusercontent.com/sierraindiagolf/openwrt-backup/refs/heads/main/setup.sh
~~~


Run setup

~~~
chmod +x setup.sh
chmod +x backup.sh
./setup.sh --hostname <mail-server-hostnme> --from <from-email-address> --user <smtp-username> --password <smtp-password> --to <target-email-address-to-send-backup-to> --system_hostname <hostname-of-your-router>
~~~

Check that the cron job has been added correctly
~~~
cat /etc/crontabs/root
~~~

### Available options of setup.sh

| Option              	| Description                                 	| Required 	| Default  	|
|---------------------	|---------------------------------------------	|----------	|----------	|
| hostname            	| The smtp server hostname                    	| yes      	|          	|
| from                	| The address the email is being sent from    	| yes      	|          	|
| user                	| The username to use against the smtp server 	| yes      	|          	|
| password            	| The password to use against the smtp server 	| yes      	|          	|
| to                  	| The target address to send the backup to    	| yes      	|          	|
| system_hostname     	| The hostname of the router                  	| yes      	|          	|
| port                	| The smtp port                               	| no       	| 465      	|
| tls                 	| Tls on/off                                  	| no       	| on       	|
| tls_starttls        	| Tls_starttls on/off                         	| no       	| off      	|
| set_from_header     	| Set from header options for msmtp           	| no       	| on       	|
| allow_from_override 	| allow_from_override options for msmtp       	| no       	| off      	|
| syslog              	| The syslog to write to                      	| no       	| LOG_MAIL 	|


