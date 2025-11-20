# ZFS
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

## Определить настройки пула.
1) С помощью команды zfs import собрать pool ZFS.
2) Командами zfs определить настройки:
     * размер хранилища;
     * тип pool;
     * значение recordsize;
     * какое сжатие используется;
     * какая контрольная сумма используется.
 
 ### Скачиваем и импортируем pool в нашу систему:
  ```bash
      wget -O archive.tar.gz --no-check-certificate 'https://drive.usercontent.google.com/download?id=1MvrcEp-WgAQe57aDEzxSRalPAwbNN1Bb&export=download'
      tar -xzvf archive.tar.gz
      zpool import -d zpoolexport/ otus
      zpool status otus
  ```
  ```
      root@ubuntu:/home/mannaz# zpool status otus
        pool: otus
       state: ONLINE
      status: Some supported and requested features are not enabled on the pool.
              The pool can still be used, but some features are unavailable.
      action: Enable all features using 'zpool upgrade'. Once this is done,
              the pool may no longer be accessible by software that does not support
              the features. See zpool-features(7) for details.
      config:
      
              NAME                                STATE     READ WRITE CKSUM
              otus                                ONLINE       0     0     0
                mirror-0                          ONLINE       0     0     0
                  /home/mannaz/zpoolexport/filea  ONLINE       0     0     0
                  /home/mannaz/zpoolexport/fileb  ONLINE       0     0     0
      
      errors: No known data errors

  ```
#### Выводим размера хранилища:
  ```bash
      zfs get available otus
  ```
  ```
      root@ubuntu:/home/mannaz# zfs get available otus
      NAME  PROPERTY   VALUE  SOURCE
      otus  available  350M   -
  ```
#### Выводим тип хранилица:
  ```bash
      zfs get readonly otus
  ```
  ```
      root@ubuntu:/home/mannaz# zfs get readonly otus
      NAME  PROPERTY  VALUE   SOURCE
      otus  readonly  off     default
  ```
#### Выводим значение recordsize:
  ```bash
      zfs get recordsize otus
  ```
  ```
      root@ubuntu:/home/mannaz# zfs get recordsize otus
      NAME  PROPERTY    VALUE    SOURCE
      otus  recordsize  128K     local
  ```
#### Выводим тип сжатия:
  ```bash
      zfs get compression otus
  ```
  ```
      root@ubuntu:/home/mannaz# zfs get compression otus
      NAME  PROPERTY     VALUE           SOURCE
      otus  compression  zle             local
  ```
#### Выводим тип контрольных сумм:
  ```bash
      zfs get checksum otus
  ```
  ```
    root@ubuntu:/home/mannaz# zfs get checksum otus
    NAME  PROPERTY  VALUE      SOURCE
    otus  checksum  sha256     local

  ```
## Работа со snapshot
1) Cкопировать файл из удаленной директории;
2) Восстановить файл локально. zfs receive;
3) Найти зашифрованное сообщение в файле secret_message.

### Cкачиваем файл snapshot-a и восстанавливаем данные с него:
  ```bash
      wget -O otus_task2.file --no-check-certificate https://drive.usercontent.google.com/download?id=1wgxjih8YZ-cqLqaZVa0lA3h3Y029c3oI&export=download
      zfs receive otus/test@now < otus_task2.file
  ```
### Поиск зашфированного сообщения в файле secret_message
  ```bash
      find /otus/test -name "secret_message" | xargs cat
  ```
  ```
      root@ubuntu:/home/mannaz# find /otus/test -name "secret_message" | xargs cat
      https://otus.ru/lessons/linux-hl/
  ```
