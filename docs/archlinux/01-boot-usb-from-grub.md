## reboot pc

> press esc(c for command line when load grub) to enter grub2 command line interpreter

## find partitions

```bash
ls
```

## load

```bash
set root=(hd0,msdos2)
chainloader (hd0,msdos2)/efi/boot/bootx64.efi
boot
```
