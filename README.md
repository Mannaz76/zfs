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
### Создаем файловую систему на каждом zpool:
  ```bash
      zfs create test1/1
      zfs create test2/2
      zfs create test3/3
      zfs create test4/4
  ```
  ```
      root@ubuntu:~# zfs list
      NAME      USED  AVAIL     REFER  MOUNTPOINT
      test1     144K   832M       24K  /test1
      test1/1    24K   832M       24K  /test1/1
      test2     144K   832M       24K  /test2
      test2/2    24K   832M       24K  /test2/2
      test3     144K   832M       24K  /test3
      test3/3    24K   832M       24K  /test3/3
      test4     144K   832M       24K  /test4
      test4/4    24K   832M       24K  /test4/4
  ```
### Добавим разные алгоритмы сжатия в каждую файловую систему:
  ```bash
      zfs set compression=gzip test1/1
      zfs set compression=zle test2/1
      zfs set compression=lzjb test3/1
      zfs set compression=lz4 test4/1
  ```
  ```
      root@ubuntu:~# zfs get compression
      NAME     PROPERTY     VALUE           SOURCE
      test1    compression  off             default
      test1/1  compression  gzip            local
      test2    compression  off             default
      test2/1  compression  zle             local
      test3    compression  off             default
      test3/1  compression  lzjb            local
      test4    compression  off             default
      test4/1  compression  lz4             local
  ```
### Копируем файлы в файловые системы zfs:
  ```bash
      for i in {1..4}; do cp -r /var/log/* /test$i/1 ; done
  ```
### Определяем алгоритм с наилучшим сжатием:
  ```bash
      zfs get compressratio
  ```
  ```
      root@ubuntu:~# zfs get compressratio
      NAME     PROPERTY       VALUE  SOURCE
      test1    compressratio  11.78x  -
      test1/1  compressratio  12.09x  -
      test2    compressratio  2.95x  -
      test2/1  compressratio  2.96x  -
      test3    compressratio  5.60x  -
      test3/1  compressratio  5.65x  -
      test4    compressratio  8.38x  -
  ```


