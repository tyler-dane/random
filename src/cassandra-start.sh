#!/bin/bash
# chkconfig: 2345 99 01
# description: start Cassandra as systemd

# cassandra-start.sh 

# Author: Ty Hitzeman
# Date created: 10/31/2017

# Purpose: Start Cassandra on boot as the user 'ty'

# Context:
#	- Only applies to Cassandra instances that were installed via tarbell on systemd-OS's (Red Hat, CentOS, Fedora)

# Usage:
# 	- Create new service unit file at /etc/systemd/system/cassandra.service
#		- See this link for instructions on making unit files: https://access.redhat.com/solutions/1163283
#		- See this link for more info on unit files: https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/7/html/system_administrators_guide/sect-Managing_Services_with_systemd-Unit_Files#sect-Managing_Services_with_systemd-Unit_File_Structure
#		- See bottom of this file for an example of /etc/systemd/system/cassandra.service
#	- Create cassandra-start.sh. Consider saving it in same directory as the Cassandra foler (e.g. `touch ~/home/tyler/bin/apache-cassandra-3.9/cassandra-start.sh
#	- Make this script executable (chomd +x start-cassandra.sh)
#	- Test: `systemctl start cassandra && systemctl status cassandra`
#		- Note: This may show cassandra as "Inactive" or "Dead", even though it is, in fact, running. Refer to the output of `ps aux | grep cassandra` for confirmation
#	- Make new cassandra systemd service start on boot: `systemctl enable cassandra.service`
#		- If you have trouble with this, you may have to copy the unit file into /etc/init.d/cassandra and then run a chkconfig command first.
#			- For example: 
#				cp ~/home/tyler/bin/apache-cassandra-3.9/cassandra-start /etc/init.d/cassandra 
#				chkconfig --add cassandra
#				systemctl enable cassandra.service
#	- Test by rebooting and running `systemctl status cassandra.service` and `ps aux | grep cassandra`

# Tip:
#	Consider creating aliases for Cassandra in your ~/.bashrc file:
#		alias startcass='sudo /etc/init.d/cassandra-start-on-boot.sh'
#		alias killcass='pgrep -u tyler -f cassandra | xargs kill -9'
#		alias restartcass='pgrep -u tyler -f cassandra | xargs kill -9 && sudo /etc/init.d/cassandra-start-on-boot.sh'

runuser -l tyler -c '/home/ty/bin/apache-cassandra-3.9/bin/cassandra'




### Example of /etc/systemd/system/cassandra.service :
#[Unit]
#Description=Apache Cassandra 3.9 daemon. Installed via tarbell in ~/bin/apache[...]
#After=network.target
#
#[Service]
#Type=simple
#ExecStart =/home/tyler/bin/apache-cassandra-3.9/cassandra-start.sh
#
#[Install]
#WantedBy=default.target

