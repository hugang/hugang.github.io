## keyboard layout

```bash
loadkeys jp106
```
## make wlan0 up
```bash
ip link set wlan0 up
```

## scan available wifi
```bash
iwlist wlan0 scan | grep ESSID
```

## generate wifi config
```bash
wpa_passphrase WIFI-ID PASSWD > wlan.cfg
```

## connect wifi with generated config in background
```bash
wpa_supplicant -c wlan.cfg -i wlan0 &
```

## test connection
```bash
ping www.google.com
```

## sync date
```bash
timedatectl set-ntp true
```
