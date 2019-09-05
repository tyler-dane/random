These are programs, cheatsheets, and tutorials for projects that I have completed. I am sharing them here in hopes that someone else might find them useful. 

# Source Code
### Bash
[*Securely* Run Bash Script on Remote Server as Root](src/ssh-rpm-install.sh)
- Authenticate and run commands without sending passwords in plain-text

[Send email whenever disk space hits 80% capacity](src/email-storage-alert.sh)
- Useful script that prevents your disk from filling up without your knowledge

### Python
[Revert multiple VMs to snapshots from the CLI](https://github.com/vmware/pyvmomi-community-samples/pull/483)
- Uses the pyVmomi Python library to revert vSphere VMs to their respective snapshots

# [Cheatsheets](https://github.com/tyler-hitzeman/cheatsheets)
Handy cheatsheets for Unix/Linux developers and system administrators

# Tutorials
 
### [Bacula](https://github.com/tyler-hitzeman/bacula)
- Backups are important. Bacula, an open-source client/server backup program, may be a good option for those intersted in automating their backups. 

### Cassandra
[Enable JMX on a Cassandra Cluster](cassandra/cassandra-jconsole-monitor.md)
- JMX allows you to get metrics on the performance of a Cassandra node

[Start Cassandra on boot](src/cassandra-start.sh) (tarbell installs only)
- Manually create and enable a systemd service for Cassandra

[Store Cassandra's commit log on a second drive](cassandra/cassandra-separate-drives.md)
- It is often advised to run Apache Cassandra's data on SSDs and commit log on HDDs. This document is meant to give an overview of this process. 

### Docker
[Docker Tutorial for Java Developers](docker-for-java-tutorial.md)
- This tutorial is based on Arun Gupta's [**Docker for Java Developers**](https://www.lynda.com/Docker-tutorials/Docker-Java-developers/576584-2.html) course on Lynda.com
- Intended audience: Java developers who are new to Docker
- Purpose: Quickly show the steps needed to set up a Java development environment using Docker. 

### Git
[Remove credentials from repository using BFG](git-clean-repo.md)

### GitLab
[Automatically send GitLab backups to AWS S3](gitlab/backup-recover.md)

[Recover from GitLab backups](gitlab/backup-recover.md)
- What good are you backups if you can't recover from them?

[Troubleshooting](gitlab/troubleshooting.md)

### VMware vSphere
[Add a Synology NAS as a vSphere NTFS datastore](vmware/nas-datastore.md)

[Share a Linux directory across your VMware Datacenter via NFS](vmware/nfs-mount-linux-vmware.md)

### Other  
#### Fedora
[Dual-boot Fedora and Windows 10](dual-boot-fedora-windows10.md)
- How to reinstall your Fedora OS on a dual-booted computer with Windows 10.

#### FFmpeg
[ffmpeg Tutorial](ffmpeg-tutorial.md)
- FFmpeg is the leading multimedia framework, able to decode, encode, transcode, mux, demux, stream, filter and play pretty much anything that humans and machines have created.

#### Wordpress
[Install Wordpress on Ubuntu Server](wordpress-ubuntu-setup.md)
- WordPress is a free and open-source content management system (CMS) based on PHP and MySQL.