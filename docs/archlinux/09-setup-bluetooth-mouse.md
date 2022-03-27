## install packages
```bash
pacman -S bluez bluez-utils
```

## start service
```bash
systemctl start bluetooth
```

## set up device
```bash
bluetoothctl
    power on
    scan on
    connect BLUETOOTH-ID
    trust BLUETOOTH-ID
    pair BLUETOOTH-ID
```

