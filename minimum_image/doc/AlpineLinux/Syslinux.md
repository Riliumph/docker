# [Syslinux](https://wiki.syslinux.org/wiki/index.php?title=SYSLINUX)

Linux Kernelを起動するためのブートローダーの一つ。

> 一般的なLinux Distributionでは`GRUB`が採用されている。

`GRUB`は巨大なソフトウェアのため、軽量化のために`Syslinux`が採用される。  

フロッピーディスクの時代から使われているブートローダー。  
元をたどればMS-DOSのFATファイルシステム向けに開発されていた。  
Linuxのext2/3/4のファイルシステムには`Extlinux`が使われていたが、現在は統合されている。

最新バージョンも2014年リリースの6.03のため「枯れたソフトウェア」である。  
頻繁なアップデートはないものと思うべき。

## サポートしているファイルシステム

- FAT12/16/32
- ext2/3/4
- Btrfs
- XFS
- UFS/FFS
- NTFS
- ISO 9660

以下は対応していないので注意

- exFAT
- ZFS
- HFS
