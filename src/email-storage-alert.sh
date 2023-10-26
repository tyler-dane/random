#!/bin/sh

# Sends email to tyler@gmail.com whenever disk space is over 80%
# Cron configured to execute this daily
# Requires the 'mailx' package.
#   On RedHat systems, run `yum install mailx` to install

df -H | grep -vE '^Filesystem|tmpfs|cdrom' | awk '{ print $5 " " $1 }' | while read output;
do
  echo $output
  usep=$(echo $output | awk '{ print $1}' | cut -d'%' -f1  )
  partition=$(echo $output | awk '{ print $2 }' )
  if [ $usep -ge 80 ]; then
    echo "Running out of space \"$partition ($usep%)\" on $(hostname) as on $(date)" |
     mail -s "Alert: $usep% of disk space used." tyler@gmail.com
  fi
done
