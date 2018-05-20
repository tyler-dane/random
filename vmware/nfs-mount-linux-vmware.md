Share a directory on a Linux machine across your VMware Datacenter via NFS

### Reference: 
- [Add to /etc/exports](https://www.centos.org/docs/5/html/Deployment_Guide-en-US/s1-nfs-server-config-exports.html) [centos.org]
- [Add to /etc/fstab](https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/6/html/Storage_Administration_Guide/s3-disk-storage-parted-create-part-fstab.html) [redhat.com]


## On Linux Server:
- Create directory:
  - `mkdir -p /mnt/vmware`
- Ensure mountpoint mounts on boot
- Edit `/etc/exports`:
  - `vim /etc/exports`
- Apply changes:
  - ` exportfs -ra`
 - Restart nfs:
  - `service nfs restart`


## On ESXi / vCenter: 
- Datacenter > Datastores > New Datastore
- Location: `YourDataCenter`
- Type: `NFS`
- NFS version: `4.1`
  - Or whatever version your server supports
- Datasore name: `Name`
  - I prefer to include the IP in the name
- Enable Kerberos-based authentication: (Optional)
- (Select Hosts that should have access to this datastore)
- Finish
