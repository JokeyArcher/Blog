# Arch Linux 基本配置

## 网络配置

* 有线连接：

开机启动启动dhcp服务

```bash
sudo systemctl start dhcpcd
sudo systemctl enable dhcpcd
```

* 无线连接：

```bash
sudo pacman -S iw wpa_supplicant dialog
```

## 添加 Arch Linux CN 源

这里选择的是ustc的软件源，编辑 `/etc/pacman.conf` 文件末尾添加两行：

```bash
[archlinuxcn]
Server = https://mirrors.ustc.edu.cn/archlinuxcn/$arch
```

然后请执行安装 `sudo pacman -S archlinuxcn-keyring` 以导入 GPG key。
然后刷新源：

```bash
sudo pacman -Syy
```

## 添加 AUR 仓库

以前的`AUR` 助手工具 `yaourt` 已经停止开发，新的替代品有： [aurman](https://github.com/polygamma/aurman)、[yay](https://github.com/Jguer/yay) 等。这里已 `yay` 为例， `yay` 是基于 `Go` 语言的，会安装依赖包。

```bash
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
```

`yay` 跟 `pacman` 用法相似，基本能替代。

## 安装显卡驱动

确定显卡型号
执行:

```bash
lspci | grep VGA
```

官方仓库提供的驱动包：
| 包名 | 适用类型 |
|---|---|
| xf86-video-vesa     | 通用 |
| xf86-video-intel    | intel |
| xf86-video-ati      | amd |
| xf86-video-nouveau  | Geforce7+ |
| xf86-video-304xx    | Geforce6/7 |

安装：

```bash
yay -S 驱动包
```

## 安装音频驱动

```bash
yay -S alsa-utils
```

> 双显卡：请拔掉显卡提升性能。。。没折腾过自己折腾吧。

## 安装X窗口系统

```bash
yay -S xorg-server xorg-xprop xorg-xrandr xorg-xrdb
```

## 中文配置和中文输入法

* 安装中文字体，更多配置请查看 [Fonts](https://wiki.archlinux.org/index.php/Fonts)

```bash
yay -S ttf-dejavu wqy-zenhei
```

* 中文输入法

```bash
yay -S fcitx-im fcitx-sogoupinyin
```

全部安装即可。配置工具：如果桌面环境准备安装 `KDE` 则安装 `kcm-fcitx`, 基于 `GTK+3` 的安装 `fcitx-configtool`。

在 `~/.xinitrc` 、 `~/.xprofile` 和 `~/.bashrc 或 ~/.zshrc` 中加入：

```bash
export LANG=zh_CN.UTF-8
export LANGUAGE=zh_CN:en_US
export LC_CTYPE=en_US.UTF-8

export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx
```

## 桌面环境安装

Linux下有很多著名的桌面环境如Xfce、Gnome、KDE(Plasma)、Unity、i3wm等等，它们的外观、操作、设计理念等各方面都有所不同， 在它们之间的比较与选择网上有很多的资料可以去查。
如果实在不知道选哪个，都装上体验下也是可以的。跟多信息可以查看 [Desktop environment](https://wiki.archlinux.org/index.php/Desktop_environment#List_of_desktop_environments) 了解。

* Xfce4 桌面

```bash
yay -S xfce4 xfce4-goodies sddm
```

* Gnome 桌面

```bash
yay -S gnome gdm gnome-extra
```

* KDE 桌面

```bash
yay -S plasma kde-applications sddm
```

> xfce4-goodies、gnome-extra、kde-applications 是扩展包，可以不用安装。

开机启动登陆管理器(gdm或者sddm)：

```bash
sudo systemctl enable gdm/sddm
```

## 网络管理器

```bash
yay -S networkmanager
sudo systemctl enable NetworkManager
```

小托盘工具等其他问题可以参考 [NetworkManager](https://wiki.archlinux.org/index.php/NetworkManager)。

## ZSH 和 Oh My Zsh

安装 `zsh`：

```bash
yay -S zsh
```

安装 `Oh My Zsh`：

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
```

关于`Oh My Zsh`更多配置可以查看 [官方文档](https://github.com/robbyrussell/oh-my-zsh) 。

## 常用软件

```bash
yay -S tar git gvfs gvfs-mtp htop ranger firefox firefox-i18n-zh-cn chromium
```

更多可以查看 `Arch Wiki` 或者这个 [仓库](https://github.com/alim0x/Awesome-Linux-Software-zh_CN)。

## 重启

重新启动后，如果你看到桌面管理器的界面，选择你需要的桌面环境并输入用户名与密码登陆后，正常进入桌面，那么恭喜你，你已经完成了桌面环境的安装！

---
到这里， `ArchLinux` 的安装与基本配置教程已经结束了，如果有疏漏与不正确的地方，欢迎在评论留言中指正。之后会写一篇关于 `i3wm` 桌面的安装和配置。
