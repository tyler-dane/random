# Monitor a remote Cassandra cluster via **jconsole**
#### Purpose: 
- This document is meant to supplement Datastax's [Enable JMX Authentication for Cassandra](https://docs.datastax.com/en/cassandra/2.1/cassandra/security/secureJmxAuthentication.html) [datastax.com]. Refer to this document for context. 
- Note: Instructions are based on Red Hat systems

#### References:
- [Enable JMX Authentication for Cassandra](https://docs.datastax.com/en/cassandra/2.1/cassandra/security/secureJmxAuthentication.html) [datastax.com]
- [Cassandra Firewall Settings](https://docs.datastax.com/en/cassandra/2.1/cassandra/security/secureFireWall_r.html) [datastax.com]

## Edit Cassandra Configs

### **jmxremote.password**:
Copy password file:
- Note: These files should be present by default on most Red Hat systems. If not, trying `yum install`ing them. 
```
cp /usr/lib/jvm/java-1.8.0-openjdk-1.8.0.151-1.b12.el7_4.x86_64/jre/lib/management/jmxremote.password.template /etc/cassandra/jmxremote.password

chown cassandra:cassandra /etc/cassandra/jmxremote.password
chmod 400 /etc/cassandra/jmxremote.password
```

`vim /etc/cassandra/jmxremote.password`:

```
monitorRole QED
controlRole R&D
cassandrauser cassandrapassword

```

### **jmxremote.access**:
`vim /usr/lib/jvm/java-1.8.0-openjdk-1.8.0.151-1.b12.el7_4.x86_64/jre/lib/management/jmxremote.access`:

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
- Check to make sure the spacing in each of the configs is consistent (I used four spaces between values in mine, although the datastax documentaion seems to only use two)