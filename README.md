# zfs
## Определить алгоритм с наилучшим сжатием:
1) определить, какие алгоритмы сжатия поддерживает zfs (gzip, zle, lzjb, lz4);
2) создать 4 файловых системы, на каждой применить свой алгоритм сжатия;
3) для сжатия использовать либо текстовый файл, либо группу файлов.

### Устанавливаем пакет утилит для ZFS:
  ```bash
      apt update && apt install zfsutils-linux
  ```
### Сохдаем 4 zpool из двух дисков в RAID 1:
  ```bash
      zpool create test1 mirror /dev/sdb /dev/sdc
      zpool create test2 mirror /dev/sdd /dev/sde
      zpool create test3 mirror /dev/sdf /dev/sdg
      zpool create test4 mirror /dev/sdh /dev/sdi
  ```
  ```
      root@ubuntu:~# zpool list
      NAME    SIZE  ALLOC   FREE  CKPOINT  EXPANDSZ   FRAG    CAP  DEDUP    HEALTH  ALTROOT
      test1   960M   106K   960M        -         -     0%     0%  1.00x    ONLINE  -
      test2   960M   100K   960M        -         -     0%     0%  1.00x    ONLINE  -
      test3   960M   100K   960M        -         -     0%     0%  1.00x    ONLINE  -
      test4   960M   100K   960M        -         -     0%     0%  1.00x    ONLINE  -

  ```
### Устанавливаем пакет утилит для ZFS:
  ```bash
  ```
### Устанавливаем пакет утилит для ZFS:
  ```bash
  ```
