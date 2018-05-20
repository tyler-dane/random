# Fresh Install of Fedora on a dual-booted Computer with Windows 10

- This tutorial briefly explains how to reinstall your Fedora OS on a dual-booted computer with Windows 10.
- It is meant to supplement the dual-boot tutorial at [Tecmint.com](https://www.tecmint.com/install-fedora-27-with-windows-10-or-8-in-dual-boot/).

### Record devices and their current mount points
- These will come in handy later

```
[ty@localhost]$ lsblk
NAME            MAJ:MIN RM   SIZE RO TYPE MOUNTPOINT
sda               8:0    0 238.5G  0 disk 
├─sda1            8:1    0   260M  0 part /boot/efi
├─sda2            8:2    0    16M  0 part 
├─sda3            8:3    0  82.1G  0 part 
├─sda4            8:4    0  1000M  0 part 
├─sda5            8:5    0     1G  0 part /boot
└─sda6            8:6    0 154.1G  0 part 
  ├─fedora-root 253:0    0    50G  0 lvm  /
  ├─fedora-swap 253:1    0   7.8G  0 lvm  
  └─fedora-home 253:2    0  96.4G  0 lvm  /home

```
- Note: `sda3` is my Windows partition



### Record filesystem types

```
[ty@localhost]$ df -T
Filesystem              Type     1K-blocks      Used Available Use% Mounted on
devtmpfs                devtmpfs   3992536         0   3992536   0% /dev
tmpfs                   tmpfs      4005832    154656   3851176   4% /dev/shm
tmpfs                   tmpfs      4005832      2240   4003592   1% /run
tmpfs                   tmpfs      4005832         0   4005832   0% /sys/fs/cgroup
/dev/mapper/fedora-root ext4      51343840   8443448  40262568  18% /
tmpfs                   tmpfs      4005832       220   4005612   1% /tmp
/dev/sda5               ext4        999320    278852    651656  30% /boot
/dev/sda1               vfat        262144     55812    206332  22% /boot/efi
/dev/mapper/fedora-home ext4      99339424  57160632  37109584  61% /home
tmpfs                   tmpfs       801164        16    801148   1% /run/user/42
tmpfs                   tmpfs       801164      7304    793860   1% /run/user/1000
```
- Record info under the `type` column for each partition you plan on recreating for your new install

### Create and test a backup of your critical data
### Download ISO from Fedora's website
### Burn ISO to a DVD/USB
- Install packages needed to burn DVD/USB

```
sudo dnf install wodim inxi
```

- Plug USB/DVD writer into computer
- Find location to your DVD/USB: `wodim --devices`
    - e.g. `/dev/sr0`
- Run command to burn ISO:

```
wodim -eject -tao speed=2 dev=/dev/sr0 -v -data ~/Downloads/Fedora-Workstation-Live-x86_64-27-1.6.iso 
```


**Output:**

```TOC Type: 1 = CD-ROM
scsidev: '/dev/sr0'
devname: '/dev/sr0'
scsibus: -2 target: -2 lun: -2
Linux sg driver version: 3.5.27
Wodim version: 1.1.11
SCSI buffer size: 64512
Device type    : Removable CD-ROM
Version        : 0
Response Format: 2
Capabilities   : 
Vendor_info    : 'HL-DT-ST'
Identification : 'DVDRAM GP60NB50 '
Revision       : 'PE00'
Device seems to be: Generic mmc2 DVD-R/DVD-RW.
Current: 0x0011 (DVD-R sequential recording)
Profile: 0x0015 (DVD-R/DL sequential recording) 
Profile: 0x0016 (DVD-R/DL layer jump recording) 
Profile: 0x002B (DVD+R/DL) 
Profile: 0x001B (DVD+R) 
Profile: 0x001A (DVD+RW) 
Profile: 0x0014 (DVD-RW sequential recording) 
Profile: 0x0013 (DVD-RW restricted overwrite) 
Profile: 0x0012 (DVD-RAM) 
Profile: 0x0011 (DVD-R sequential recording) (current)
Profile: 0x0010 (DVD-ROM) 
Profile: 0x000A (CD-RW) 
Profile: 0x0009 (CD-R) 
Profile: 0x0008 (CD-ROM) 
Profile: 0x0002 (Removable disk) 
Using generic SCSI-3/mmc DVD-R(W) driver (mmc_mdvd).
Driver flags   : SWABAUDIO BURNFREE 
Supported modes: PACKET SAO
Drive buf size : 555008 = 542 KB
Beginning DMA speed test. Set CDR_NODMATEST environment variable if device
communication breaks or freezes immediately after that.
FIFO size      : 4194304 = 4096 KB
Track 01: data  1556 MB        
Total size:     1786 MB (177:02.29) = 796672 sectors
Lout start:     1787 MB (177:04/22) = 796672 sectors
Current Secsize: 2048
HINT: use dvd+rw-mediainfo from dvd+rw-tools for information extraction.
Blocks total: 2298496 Blocks current: 2298496 Blocks remaining: 1501824
Speed set to 5540 KB/s
Starting to write CD/DVD at speed   4.0 in real unknown mode for single session.
Last chance to quit, starting real write in    0 seconds. Operation starts.
Waiting for reader process to fill input buffer ... input buffer ready.
Performing OPC...
Starting new track at sector: 0
Track 01: 1556 of 1556 MB written (fifo 100%) [buf  95%]   4.1x.
Track 01: Total bytes read/written: 1631584256/1631584256 (796672 sectors).
Writing  time:  355.430s
Average write speed   3.5x.
Min drive buffer fill was 92%
Fixating...
Fixating time:   20.864s
wodim: fifo had 25700 puts and 25700 gets.
wodim: fifo was 0 times empty and 14546 times full, min fill was 90%.
```

### Restart computer
### Press `F12` upon seeing the OS's splash screen
- Your computer may require a different key than `F12`. Consult your manufacturer's manual. 

### Follow instructions in [Tecmint's](https://www.tecmint.com/install-fedora-27-with-windows-10-or-8-in-dual-boot/) for instructions on installing the OS
- Remember that you need to set a mount point for your `/`, `/boot`, and `/home` partitions before booting. Use the info you recorded from running `lsblk` to decide which partition to use.
- You will need to format your existing root partition and set the file system type. Use the file system you wrote down after running `df -T` if you'd like to use the one as before.
