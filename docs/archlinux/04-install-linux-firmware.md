## make sure the fastest mirror at top of list
```bash
vim /etc/pacman.d/mirrorlist
```
## mount /
```bash
mount /dev/nvme0n1p2 /mnt
```
## mount /boot form efi partition
```bash
mkdir /mnt/boot
mount /dev/nvme0n1p1 /mnt/boot
```
## install basic packages
```bash
pacstrap /mnt base linux linux-firmware
```
## generate fstab
```bash
genfstab -U /mnt >> /mnt/etc/fstab

```
