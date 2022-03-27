## login new system
```bash
arch-chroot /mnt
```

## develop tools, network tools
```bash
pacman -S vim base-devel wpa_supplicant dhcpcd networkmanager
```

## set time zone
```bash
ln -sf /usr/share/zoneinfo/Asia/Tokyo /etc/localtime
hwclock --systohc
```

## generate locale
```bash
vim /etc/locale.gen uncomment en_US.UTF-8
locale-gen

vim /etc/locale.conf
LANG=en_US.UTF-8
```

## keyboard layout
```bash
vim /etc/vconsole.conf
KEYMAP=jp106
```

## hostname
```bash
vim /etc/hostname
hg
```

## hosts
```bash
vim /etc/hosts
127.0.0.1	localhost
::1				localhost
127.0.0.1	hg.localdomain hg
```

## set root passwd
```bash
passwd
```
