## add a non root user
```bash
add user
useradd -d /home/hg -G wheel hg
passwd hg

```

## enable sudo for wheel group

```bash
pacman -S sudo
export EDITOR=vim
visudo

# then uncomment wheel for sudo
```

## enable network manager service
```bash
# connect to wifi
ip link set wlan0 up
systemctl enable NetworkManager
systemctl start NetworkManager
nmcli dev wifi connect WIFI-ID password PASSWD
```



