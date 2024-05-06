#!/bin/bash

echo "欢迎使用此脚本"
echo "此脚本仅支持Redhat、Centos、版本7~9"
echo "脚本功能：升级Gun/nano编辑器到8.0"
echo "本脚本会创建/opt/nano-8.0以存放nano二进制文件"
sleep 4s 

# 检查当前用户是否为root
if [ "$EUID" -ne 0 ]; then
    if ! command -v sudo &> /dev/null; then
        echo "sudo命令不存在，请安装sudo或以root权限运行此脚本"
        exit 1
    else
        echo "权限需要提升: 该脚本必须由root或sudo执行"
        echo "请使用sudo来执行此脚本或切换到root用户"
        exit 1
    fi
fi

# 安装必要库
echo "安装必要库"
echo "sudo yum install wget xz tar ncurses-devel -y"
sudo yum install wget xz tar ncurses-devel -y
echo "必要库安装完毕"

#下载nano源代码包
echo "下载nano源代码包"
echo "wget https://www.nano-editor.org/dist/v8/nano-8.0.tar.xz"
wget https://www.nano-editor.org/dist/v8/nano-8.0.tar.xz
#解压源码包
echo "解压源码包"
unxz nano-8.0.tar.xz
tar -xvf nano-8.0.tar
cd nano-8.0
#编译安装
echo "编译安装nano"
./configure -prefix=/opt/nano-8.0
echo "配置完毕，3s后开始安装"
sleep 3s
make
make install
echo "安装完毕，准备替换原有文件"
sleep 2s
echo "备份原有文件"
echo "mv /usr/bin/nano /usr/bin/nano.bak"
mv /usr/bin/nano /usr/bin/nano.bak
echo "mv /usr/bin/nano /usr/bin/nano.bak"
mv /usr/share/nano /usr/bin/nano.bak

#创建软连接
ln -s /opt/nano-8.0/bin/nano /usr/bin/nano
ln -s /opt/nano-8.0/share/nano /usr/share/nano
echo "软连接创建完毕"

nano -V
echo "安装完毕，脚本退出，感谢使用！"
