zpool create test1 mirror /dev/sdb /dev/sdc
zpool create test2 mirror /dev/sdd /dev/sde
zpool create test3 mirror /dev/sdf /dev/sdg
zpool create test4 mirror /dev/sdh /dev/sdi

zfs create test1/1
zfs create test2/2
zfs create test3/3
zfs create test4/4

zfs set compression=gzip test1/1
zfs set compression=zle test2/1
zfs set compression=lzjb test3/1
zfs set compression=lz4 test4/1

for i in {1..4}; do cp -r /var/log/* /test$i/1 ; done

