# Monitor a remote Cassandra cluster via **jconsole**
#### Purpose: 
This is meant to be a supplement to Datastax's [Enable JMX Authentication for Cassandra](https://docs.datastax.com/en/cassandra/2.1/cassandra/security/secureJmxAuthentication.html). Use that document as your main guide, and refer to the more verbose examples here if needed. 
- Note: Instructions are based on Red Hat syntax and Java 1.8

## Edit Cassandra Configs

Disable local JMX (step 1)

`vi /etc/cassandra/conf/cassandra-env.sh`
```
if [ "x$LOCAL_JMX" = "x" ]; then
    LOCAL_JMX=no
fi
```

### **jmxremote.password**:
Copy password file (step 2):
- Note: These files should be present by default on most Red Hat systems. If not, trying `yum install`ing them. 
```
cp /usr/lib/jvm/java-1.8.0-openjdk-1.8.0.171-7.b10.el7.x86_64/jre/lib/management/jmxremote.password.template /etc/cassandra/jmxremote.password
```

Change permissions (step 3)
```
chown cassandra:cassandra /etc/cassandra/jmxremote.password
chmod 400 /etc/cassandra/jmxremote.password
```

Edit passwords (step 4)

`vi /etc/cassandra/jmxremote.password`

```
monitorRole QED
controlRole R&D
cassandrauser cassandrapassword
```
- uncomment the `monitorRole` and `controlRole` lines
- add the `cassandrauser   readwrite` line. Be sure to user the actual cassandra user's name (not cassandrauser)
- try to keep consistent spacing with the other lines. 

### **jmxremote.access**:
`vi /usr/lib/jvm/java-1.8.0-openjdk-1.8.0.171-7.b10.el7.x86_64/jre/lib/management/jmxremote.access`

```
monitorRole readonly
cassandrauser readwrite     #This is the only line that needs to be changed
controlRole readwrite \
create javax.management.monitor.,javax.management.timer. \
unregister
```


## Open Firewall ports

```
firewall-cmd --zone=public --add-port=7199/tcp --permanent
firewall-cmd --zone=public --add-port=7000-7001/tcp --permanent
firewall-cmd --reload
```

- See [Cassandra Firewall Settings](https://docs.datastax.com/en/cassandra/2.1/cassandra/security/secureFireWall_r.html) [datastax.com] for more info

## Restart Cassandra (step 6)
```
systemctl restart cassandra
```

# Connect from a Remote Workstation
Notes
- Workstation should have JDK installed

Run `jconsole` from a terminal
- A GUI should pop up
- Select `Remote Process`, enter info, and click `Connect`. Examples below.
    - Host: `192.168.0.110:7199`
    - Username: `cassandrauser`
    - Password: `cassandrapassword`
- Make sure you're entering your Cassandra credentials, not those for the remote server. 

If the host and port are correct, you will see a pop-up asking if you'd like to continue authenticating without SSL. If acceptable for your environment, select `Insecure connection` to proceed. 

If your Cassandra configuration, credentials, and remote firewall settings are correct, you should proceed to the monitoring console dashboard. 

## Troubleshooting
`The Connection to <cassandrauser>@<host>:7199 did not succeed. Would you like to try again?`
- Firewall ports open? 
- Uncomment from `cassandra-env.sh`: `JVM_OPTS="$JVM_OPTS -Dcom.sun.management.jmxremote.access.file=/etc/cassandra/jmxremote.access"
` (I haven't tested this method)
- make sure `jmxremote.access` is not `jmx.remote.access` (or visa-versa)
- Check to make sure the spacing in each of the configs is consistent (I used four spaces between values in mine, although the datastax documentaion seems to only use two)