# Separate Cassandra commit log to a second drive on a VM
### Purpose: 
- It is often advised to run Apache Cassandra's data on SSDs and commit log on HDDs. This document is meant to give an overview of this process. 
- Note: Although this process should work on many systems, I tested it in a VMware environment with a Red Hat VM. 

### References:
[Create and Mount XFS file system](https://linoxide.com/file-system/create-mount-extend-xfs-filesystem/) [linoxide.com]


## Add additional disk to VM in vSphere
- Select datastore with hard drives

## Incorporate new disk
- Verify that the VM recognizes the new disk:

```
lsblk
```
- This should show another disk available (`sdb` in the example output below)

```
NAME          MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
sda             8:0    0  130G  0 disk 
├─sda1          8:1    0    1G  0 part /boot
└─sda2          8:2    0  129G  0 part 
  ├─rhel-root 253:0    0   50G  0 lvm  /
  ├─rhel-swap 253:1    0  7.9G  0 lvm  [SWAP]
  └─rhel-home 253:2    0 71.1G  0 lvm  /home
sdb             8:16   0   50G  0 disk 
sr0            11:0    1  3.7G  0 rom
```

## Create partition

```
# fdisk /dev/sdb
Welcome to fdisk (util-linux 2.23.2).

Changes will remain in memory only, until you decide to write them.
Be careful before using the write command.

Device does not contain a recognized partition table
Building a new DOS disklabel with disk identifier 0x5ece155c.

Command (m for help): n
Partition type:
   p   primary (0 primary, 0 extended, 4 free)
   e   extended
Select (default p): p
Partition number (1-4, default 1): 
First sector (2048-104857599, default 2048): 
Using default value 2048
Last sector, +sectors or +size{K,M,G} (2048-104857599, default 104857599): +50G
Value out of range.
Last sector, +sectors or +size{K,M,G} (2048-104857599, default 104857599): +49G
Partition 1 of type Linux and of size 49 GiB is set

Command (m for help): w
The partition table has been altered!

Calling ioctl() to re-read partition table.
Syncing disks.
```

## Create file system

```
mkfs.xfs /dev/sdb1 2> /dev/null
```
- Feel free to remove `2> /dev/null` if you want to view the output

## Mount file system

```
mkdir /mnt/hd
mount /dev/sdb1 /mnt/hd
```

## Enable HD to mount on boot:
`vim /etc/fstab`:
  - Add the below line to the end of the file, then save and exit.

  ```
  /dev/sdb1               /mnt/hd                 xfs     defaults        0 0
  ```


## Verify it worked:

```
mount | grep /dev/sdb1
```

```
df -T | grep /dev/sdb1
```

- The output should list the /dev/sdb1 device, the file system type (`xfs`), and the mount point (`/mnt/hd`). 

## Make sure drive is mounted on boot:

`vim /etc/fstab`
- Add line to bottom of file:

```
/dev/sdb1               /mnt/hd                 xfs     defaults,nodev,nosuid        0 0
```
- Reboot system and run `df -h | grep /dev/sdb1` to verify it was automatically mounted

## Change ownership of mounted directory to `cassandra`

```
chown -R cassandra:cassandra /mnt/hd
```

## Update `cassandra.yaml`
- Change `commitlog_directory` to `/mnt/hd`

