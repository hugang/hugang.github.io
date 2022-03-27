## 1) Install OpenVMTools

	sudo pacman -S open-vm-tools

## 2) Install drivers and libraries

	sudo pacman -Su xf86-input-vmmouse xf86-video-vmware mesa gtk2 gtkmm

## 3) Create / Edit /etc/X11/Xwrapper.config

	sudo echo needs_root_rights=yes >>/etc/X11/Xwrapper.config

## 4) Enable and start vmtoolsd.service

	sudo systemctl enable vmtoolsd
	sudo systemctl start vmtoolsd
