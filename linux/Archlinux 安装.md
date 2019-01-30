# Arch Linux 安装篇

用Linux也有两年多了，也尝试过很多发行版。特别喜欢ArchLinux的滚动更新和可定制性。ArchLinux或者是Linux的优点就不在这里多说了，我相信打开这篇教程的同学一定可以从这样的过程中得到很多。但是Arch安装对一些没经验的用户，并不那么友好。所以这次趁换电脑重装一遍，写下这篇教程。

## 准备工作

准备一个U盘，从[官网](https://www.archlinux.org/download/)下载最新安装镜像后，用[PowerISO](http://www.poweriso.com/)制作好启动U盘。制作步骤，这里不做过多介绍了。启动电脑选择U盘启动，进入界面后直接回车进入。
> U盘大小建议4G以上，记得备份好U盘数据。制作工具也可以用你熟悉的软件或者直接用`dd`命令。

## 磁盘分区和挂载

磁盘分区采用的是 [parted](https://wiki.archlinux.org/index.php/Parted) 命令和`UEFI`分区方案。如需采用`MBR`方案请查看 [parted](https://wiki.archlinux.org/index.php/Parted) 示例。分区前可以使用`lsblk`查看分区挂在情况。下面以一块新磁盘`sda`为例。

```bash
parted /dev/sda
mktable  # 磁盘格式填写ESP
mkpart esp fat32 1MiB 200MiB #建立esp分区
mkpart primary linux-swap 200M  8G # 建立swap分区
mkpart primary ext4 8G 20.5G # 建立根分区
mkpart primary ext4 20.5G 100% # 建立home分区
```

上面是将`sda`分成4个分区，当然你也可以根据自己的喜好划分。`esp`主要用来存放引导文件；`swap`交换分区，可以看做Windows的虚拟内存，该分区的大小设定可以参考[这篇文章](https://blog.csdn.net/wash168/article/details/78473846);`根分区`存放系统文件；`Home分区`存放用户相关。
分区后接下来需要格式化分区和挂载分区。

```bash
# 格式化分区
mkfs.fat -F32 /dev/sda1
mkswap /dev/sda2
mkfs.ext4 /dev/sda3
mkfs.ext4 /dev/sda4
# 挂载/启用分区
swapon /dev/sda2
mount /dev/sda3 /mnt
mkdir -p /mnt/boot/EFI # 建立EFI文件夹
mount /dev/sda1 /mnt/boot/EFI # 挂载EFI分区
mkdir /mnt/home # 建立home文件夹
mount /dev/sda4 /mnt/home # 挂载home分区
```

## 安装基本系统

**ArchLinux** 并不支持离线安装，所以安装系统前，需要连接网络。如果使用有线网并且路由器支持dhcp，插上线可以执行命令`dhcpcd`;如果是无线连接，输入命令 `wifi-menu` 选择你的 WiFi,输入密码回车稍等就连接啦。然后测试一下：`ping -c 3 baidu.com` 看看通了没。接下来需要配置下源：

编辑 mirrorlist 文件

```bash
nano /etc/pacman.d/mirrorlist
```

在文件最上方添加

```bash
Server = http://mirrors.ustc.edu.cn/archlinux/$repo/os/$arch
Server = http://mirrors.163.com/archlinux/$repo/os/$arch
```

刷新并应用

```bash
pacman -Syy
```

基本系统安装

```bash
pacstrap /mnt base base-devel
```

> 期间会进行网络下载，你可以抽根烟或喝咖啡冷静冷静...

## 配置系统

生成 **fstab** 文件

```bash
genfstab -U -p /mnt >> /mnt/etc/fstab
```

**fstab** 文件比较重要,需要检查 **fstab** 文件是否正确和备份：

```bash
# 查看 fstab 文件内容
cat /mnt/etc/fstab
#备份fstab
cp /mnt/etc/fstab /mnt/etc/fstab.bak
```

## 切换到新系统

```bash
arch-chroot /mnt /bin/bash
```

## 本地化

```bash
nano /etc/locale.gen
```

移除下方 2 个前的 # 保存即可

```bash
en_US.UTF-8 UTF-8
zh_CN.UTF-8 UTF-8
```

执行 `locale-gen` 生成并应用，然后创建locale.conf配置文件

```bash
echo LANG=en_US.UTF-8 > /etc/locale.conf
```

> 此处不建议直接将locale设置成中文: zh_CN.UTF-8，设置为 en_US.UTF-8，系统的 Log 会以英文显示，这样更容易判断问题和处理。

## 时区设置

```bash
ln -s /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
```

> 此处在新的安装镜像中，会提示 localtime 已经存在，可以先删除`rm /etc/localtime`，然后在执行该条命令。

设置硬件为 UTC 时间

```bash
hwclock --systohc --utc
```

## 设置主机名

假设你想将 **myhostname** 设置为你的主机名称：

```bash
echo myhostname > /etc/hostname
```

建议同时在 `/etc/hosts` 中设置 `hostname`

```bash
#<ip-address> <hostname.domain.org> <hostname>
127.0.0.1   localhost.localdomain   localhost   myhostname
::1         localhost.localdomain   localhost   myhostname
```

## 添加用户和设置密码

设置密码是运行 `passwd 用户名` root用户可以直接运行 `passwd`命令。
Linux中不建议直接使用`root`账户，建议添加一个用户。

```bash
#添加用户 useradd -m -g "初始组" -G "附加组" -s "登陆shell" "用户"
useradd -m -g users -s /bin/bash username
```

给刚才的用户添加`sudo`权限：

```bash
nano /etc/sudoers
```

然后在 `root ALL=(ALL) ALL` 下面添加 `用户名 ALL=(ALL) ALL`

## 添加引导

引导的方式有很多

* 使用 Grub

```bash
pacman -S grub efibootmgr
grub-install --target=x86_64-efi --efi-directory=/boot/EFI --bootloader-id=arch_grub --recheck
grub-mkconfig -o /boot/grub/grub.cfg
```

* 使用 Systemd-boot

```bash
#安装
bootctl --path=/boot/EFI install
bootctl --path=/boot/EFI update
#配置 loader.conf
nano /boot/loader/loader.conf
timeout 30            #本行是开机时，系统选单的等待时间；
default arch        #本行是指定运行哪个启动配置文件。
#配置arch.conf
cp /usr/share/systemd/bootctl/arch.conf /boot/loader/entries/arch.conf
nano /boot/loader/entries/arch.conf
#获取 PARTUUID
blkid -s PARTUUID -o value /dev/sda6
#具体内容
title Arch Linux
linux /vmlinuz-linux
initrd /initramfs-linux.img
options root=PARTUUID=09a7b897-1a0d-4518-b2d8-19da8e89068d rw
```

* 直接使用UEFI

```bash
uefi
```

## 重启

```bash
exit # 退回安装环境
umount -R /mnt
reboot
```

使用新用户登录，登录成功,恭喜你，你已经成功安装`ArchLinux`!
