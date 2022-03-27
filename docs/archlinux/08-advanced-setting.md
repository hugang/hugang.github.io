## tools
```bash
sudo pacman -S feh man git picom acpi alsa-utils
```

## lightdm

### install

```shell
pacman -S lightdm
```

### enable lightdm autostart

```shell
systemctl enable lightdm
```

### set greeter

> vim /etc/lightdm/lightdm.conf

> uncomment greeter-session and set your own
> use ls /usr/share/xgreeters to check what you can set

## ranger

```bash
sudo pacman -S ranger
# copy config
ranger --copy-config=all
# get icon plugin (need install nerd-fonts)
mkdir ~/.config/ranger/plugins
cd ~/.config/ranger/plugins
git clone https://github.com/alexanderjeurissen/ranger_devicons --depth=1
```

## yay
```bash
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
yay google-chrome
yay lazygit
yay acpitool
```

## font
```bash
git clone https://github.com/ryanoasis/nerd-fonts.git --depth=1
cd nerd-fonts
./install.sh
```
- sarasa-gothic : font for Japanese and Chinese

## st
```bash
git clone https://git.suckless.org/st
cd st
sudo make clean install
```

## dwm
```bash
git clone https://git.suckless.org/dwm
sudo make clean install
```

## vim
```bash
mkdir ~/.vim/autoload -p
wget https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

```

## zsh

```bash
sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
cd ~/.oh-my-zsh/custom/plugins
git clone https://github.com/zsh-users/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting
```

> edit .zshrc
plugins=(zsh-autosuggestions zsh-syntax-highlighting)


## input
```bash
sudo pacman -S fcitx fcitx-im fcitx-configtool fcitx-googlepinyin

# 解决Idea无法使用输入法问题
# edit .xinitrc
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS="@im=fcitx"

# start fcitx server
fcitx &
```



## idea

```shell
# 解决dwm无法启动问题
# edit .xinitrc
export _JAVA_AWT_WM_NONREPARENTING=1
export AWT_TOOLKIT=MToolkit
```

