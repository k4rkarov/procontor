<h3 align="center">Procontor</h3>
<h1 align="center"> <img src="https://github.com/k4rkarov/Procontor/blob/main/carbon.png" alt="procontor" width="500px"></h1>

The idea behind Procontor is to automate the creation of LUKS-encrypted containers for securing sensitive projects. This ensures that all data related to a specific project is protected with a password. Always remember to store your passwords securely, such as in a password vault like `keepassxc`.

Procontor not only creates the container but also automatically mounts it, providing a convenient and secure way for you to use it for storing your data.


# Download

```
  git clone https://github.com/k4rkarov/procontor && cd procontor
```

# Usage

```
$ ./procontor.sh
Usage:
  ./procontor.sh [OPTIONS]
Options:
  -h, --help             Show this help message
  -p, --project PROJECT  Specify the project name
  -s, --size SIZE        Specify the container size (e.g., 500M, 5G)
Description:
  Procontor is a Project Container Creator designed to create LUKS-encrypted containers for handling sensitive projects and subsequently mount them for further use. Please remember the password you've set for your container!
```

# Example

```
$ ./procontor.sh -p test -s 200M
                                  _             
  _ __  _ __ ___   ___ ___  _ __ | |_ ___  _ __ 
 | '_ \| '__/ _ \ / __/ _ \| '_ \| __/ _ \| '__|
 | |_) | | | (_) | (_| (_) | | | | || (_) | |   
 | .__/|_|  \___/ \___\___/|_| |_|\__\___/|_|   
 |_|                                            

     by k4rkarov (v3.0)


01 Creating a 200M container for test-cont
0+0 records in
0+0 records out
0 bytes copied, 0,00130245 s, 0,0 kB/s

02 Encrypting the test-cont container with LUKS

WARNING!
========
This will overwrite data on test-cont irrevocably.

Are you sure? (Type 'yes' in capital letters): YES
Enter passphrase for test-cont: 
Verify passphrase: 
Key slot 0 created.
Command successful.

03 Creating the device as project-device
Enter passphrase for test-cont: 
The project-device is in /dev/mapper:
control  cryptoswap  keystore-rpool  something  project-device

04 Creating a file system in the device
meta-data=/dev/mapper/project-device isize=512    agcount=4, agsize=11776 blks
         =                       sectsz=4096  attr=2, projid32bit=1
         =                       crc=1        finobt=1, sparse=1, rmapbt=0
         =                       reflink=1    bigtime=0 inobtcount=0
data     =                       bsize=4096   blocks=47104, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
log      =internal log           bsize=4096   blocks=1221, version=2
         =                       sectsz=4096  sunit=1 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0

05 Mounting the device at /mnt/project-mount
NAME             MAJ:MIN RM   SIZE RO TYPE  MOUNTPOINTS
loop0              7:0    0   100G  0 loop  
└─something      253:2    0   100G  0 crypt /mnt/something
loop1              7:1    0   200M  0 loop  
└─project-device 253:3    0   184M  0 crypt /mnt/project-mount
zd0              230:0    0   500M  0 disk  
└─keystore-rpool 253:0    0   484M  0 crypt /run/keystore/rpool
nvme0n1          259:0    0 476,9G  0 disk  
├─nvme0n1p1      259:1    0   512M  0 part  /boot/grub
│                                           /boot/efi
├─nvme0n1p2      259:2    0     2G  0 part  
│ └─cryptoswap   253:1    0     2G  0 crypt [SWAP]
├─nvme0n1p3      259:3    0     2G  0 part  
└─nvme0n1p4      259:4    0 472,4G  0 part  

06 Changing the project-mount ownership to $USER


All done.
```
