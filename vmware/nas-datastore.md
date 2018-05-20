# Add Synology NAS as a vSphere NTFS Datastore
#### Reference:
[ESXi Lab Example](https://miketabor.com/setup-nfs-on-synology-nas-for-vmware-esxi-lab/)
## Synology NAS Interface:
These are the general steps. Consult Synology's documentation for more details. 
- Create Shared Folder
- Share folder with VMware host IP addresses
    - Allow sub-mounting

## vSphere Interface:
### Add Datastore:
- Sign in to vCenter
- Click DataCenter > Datastore
- New Datastore
- Type: `NFS`
- Version: `NFS 3`
- Datastore name: `Enter Name`
    - I like to use the NAS's IP
- Folder: `/Synology/NAS/mount/path`
    - For example: `/volumeA/vmware`
- Server: `IP address`
- Do *not* check the box that says `Mount NFS as read only`
- Finish

### Troubleshooting
#### Error: Cannot Connect Datastore
```bash
[root@esxi2:~] tail /var/log/vmkernel.log 
2017-10-12T21:58:36.289Z cpu37:34871 opID=bd32da8)World: 15446: VC opID AddDatastoreWizard-addMulti-458547-ngc-c-9b-ac93 maps to vmkernel opID bd32da8
2017-10-12T21:58:36.289Z cpu37:34871 opID=bd32da8)NFS41: NFS41_VSIMountSet:402: Mount server: 192.168.30.160, port: 2049, path: /volume1/vmware, label: Synology-NAS, security: 1 user: , options: <none>
2017-10-12T21:58:36.289Z cpu37:34871 opID=bd32da8)StorageApdHandler: 982: APD Handle  Created with lock[StorageApd-0x430a28b09130]
2017-10-12T21:58:36.289Z cpu26:33655)WARNING: NFS41: NFS41ExidNFSProcess:2022: Server doesn't support the NFS 4.1 protocol
2017-10-12T21:58:46.292Z cpu20:33655)WARNING: NFS41: NFS41ExidNFSProcess:2022: Server doesn't support the NFS 4.1 protocol
2017-10-12T21:58:56.290Z cpu37:34871 opID=bd32da8)WARNING: NFS41: NFS41FSWaitForCluster:3433: Failed to wait for the cluster to be located: Timeout
2017-10-12T21:58:56.290Z cpu37:34871 opID=bd32da8)WARNING: NFS41: NFS41_FSMount:4412: NFS41FSDoMount failed: Timeout
2017-10-12T21:58:56.290Z cpu37:34871 opID=bd32da8)StorageApdHandler: 1066: Freeing APD handle 0x430a28b09130 []
2017-10-12T21:58:56.290Z cpu37:34871 opID=bd32da8)StorageApdHandler: 1150: APD Handle freed!
2017-10-12T21:58:56.290Z cpu37:34871 opID=bd32da8)WARNING: NFS41: NFS41_VSIMountSet:410: NFS41_FSMount failed: Timeout
```

#### Potential Solution: As of 10/2017, Synolosy DSM 6 does not support NFS 4.1. Use version 3 instead. 
