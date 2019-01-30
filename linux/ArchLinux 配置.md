# Arch Linux 基本配置

## 网络配置

* 有线连接

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
sudo pacman -S 驱动包
```

## 安装X窗口系统

```bash
sudo pacman -S xorg-server xorg-xprop xorg-xrandr xorg-xrdb
```

## 字体安装