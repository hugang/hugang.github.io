## Development environments made easy.
Vagrant enables users to create and configure lightweight, reproducible, and portable development environments.

## Prerequisites
- Install the latest version of Vagrant.
- Install a virtualization product such as; `VirtualBox`, VMware Fusion, or Hyper-V.

## Initialize Vagrant
```bash
vagrant init generic/centos7
```

## Start the virtual machine
```bash
vagrant up
```

## Connect to virtual machine
```
vagrant ssh
```
## Use public network
```
config.vm.network "public_network"
```


for more vagrant use `vagrant --help`