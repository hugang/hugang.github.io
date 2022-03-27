# Linux



## 静态IP

### get dns info

```bash
cat /etc/resolv.conf
192.168.220.2
search localdomain
```

### use network namager

```bash
nmcli con show
```

### set static ip by nmcli

```bash
nmcli con mod "Wired connection 1" \
ipv4.addresses "192.168.220.150/24" \
ipv4.gateway "192.168.220.2" \
ipv4.dns "192.168.220.2" \
ipv4.dns-search "localdomain" \
ipv4.method "manual"
```

### set static ip in centos7 & centos8

```diff
/etc/sysconfig/network-scripts/ifcfg-enp3s0
 DEVICE="enp3s0"
 ONBOOT=yes
 NETBOOT=yes
 UUID="0ebc2621-6086-4d9a-a15d-c52cdf6ade01"
 IPV6INIT=no
-BOOTPROTO=dhcp
 HWADDR="08:00:27:bf:e6:ec"
 TYPE=Ethernet
 NAME="enp3s0"

+BOOTPROTO=static
+DNS1="8.8.8.8"
+DNS2="8.8.4.4"
+DOMAIN=mydomain.com
+IPADDR=192.168.100.11
+NETMASK=255.255.255.0
+GATEWAY=192.168.100.1
```