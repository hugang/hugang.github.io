## generate init boot
```bash
mkinitcpio -P
```

## grub packages
```bash
pacman -S  grub efibootmgr os-prober intel-ucode
```

## grub setting
```bash
mkdir /boot/grub
grub-mkconfig -o /boot/grub/grub.cfg
grub-install --target=x86_64-efi --efi-directory=/boot

### when no efi bootable
> grub-install --target=i386-pc /dev/sda
```

