clear

##改ROOT密码
echo && echo && echo && echo && echo
echo -e "\033[1;32m 改ROOT密码 \033[0m"
echo -e "\033[1;32m 输入密码: \033[0m"
read -p "输入密码:" val echo $val
echo -e "\033[1;32m 服务器标识: \033[0m"
read -p "服务器标识:" biaoshi echo $biaoshi
echo root:$val |sudo chpasswd root
sudo sed -i 's/^#\?PermitRootLogin.*/PermitRootLogin yes/g' /etc/ssh/sshd_config;
sudo sed -i 's/^#\?PasswordAuthentication.*/PasswordAuthentication yes/g' /etc/ssh/sshd_config;
sudo service sshd restart

clear


##关闭IPV6
echo && echo && echo
echo -e "\033[1;32m 关闭IPV6 \033[0m"
echo "net.ipv6.conf.all.disable_ipv6=1" >>/etc/sysctl.conf
echo "NETWORKING_IPV6=no" >>/etc/sysconfig/network
sed -i 's/IPV6INIT="yes"/IPV6INIT="no"/g' /etc/sysconfig/network-scripts/ifcfg-eth0
sed -i 's/GRUB_CMDLINE_LINUX="net/GRUB_CMDLINE_LINUX="ipv6.disable=1 net/g' /etc/default/grub
grub2-mkconfig -o /boot/grub2/grub.cfg
systemctl disable ip6tables.service
clear


##基础环境构建
echo && echo && echo
echo -e "\033[1;32m 基础环境构建 \033[0m"
#yum -y update
#yum -y remove openssl openssl-devel cmake
yum -y install epel-release
yum -y groupinstall "Development Tools"
yum install ntpdate -y
yum -y install certbot wget git libtool perl-core zlib-devel bzip2-devel python-devel openssl telnet
apt-get -y install wget curl xz-utils nload
yum install -y wget curl xz-utils nload
yum install -y psmisc

echo "alias ls='ls --color'" >>~/.bashrc
echo "alias ll='ls -la --color=auto'" >>~/.bashrc
echo "alias grep='grep --color=auto'" >>~/.bashrc
source ~/.bashrc
ls -l --color=auto
###修改时区

rm -rf /etc/localtime
timedatectl set-timezone Asia/Shanghai
ntpdate ntp1.aliyun.com
/sbin/hwclock --systohc
echo '/root/frps.sh' >> /etc/rc.d/rc.local
clear

##下载相关文件
echo && echo && echo
echo -e "\033[1;32m 下载相关文件 \033[0m"
wget https://raw.githubusercontent.com/helloxz/mping/master/mping.sh -O mping.sh && chmod +x mping.sh
wget https://raw.githubusercontent.com/chiakge/Linux-NetSpeed/master/tcp.sh -O tcp.sh && chmod +x tcp.sh 
wget https://github.com/V2RaySSR/Trojan/raw/master/Trojan.sh -O old-trojan.sh && chmod +x old-trojan.sh 
wget https://git.io/trojan-install -O new-trojan.sh && chmod +x new-trojan.sh 
wget https://git.io/trojan.txt -O trojan.txt
wget https://github.com/fatedier/frp/releases/download/v0.37.0/frp_0.37.0_linux_amd64.tar.gz -O frp_0.37.0_linux_amd64.tar.gz
tar zxvf frp_*.tar.gz
rm -rf .frp
mv -f frp_0.*linux_amd64 .frp
rm -rf frp_*.tar.gz
rm -rf .frp/frpc*
rm -rf .frp/frps_full.ini
wget https://raw.githubusercontent.com/imzhucn/ubuntu_base/master/frps.sh -O frps.sh && chmod +x frps.sh
wget https://raw.githubusercontent.com/imzhucn/ubuntu_base/master/frps.ini -O .frp/frps.ini
wget https://raw.githubusercontent.com/imzhucn/ubuntu_base/master/frps.service -O /usr/lib/systemd/system/frps.service && chmod +x /usr/lib/systemd/system/frps.service

sed -i "s/token = admin/token = $val/g" ~/.frp/frps.ini
sed -i "s/dashboard_pwd = admin/dashboard_pwd = $val/g" ~/.frp/frps.ini

systemctl daemon-reload
systemctl enable frps

clear

##开始安装trojan和nginx
echo && echo && echo
echo -e "\033[1;32m 开始安装trojan和nginx \033[0m"
killall nginx
bash /root/new-trojan.sh
sed -i 's:/usr/local/bin/trojan web -p 81:/usr/local/bin/trojan web:g' /etc/systemd/system/trojan-web.service
sed -i 's:/usr/local/bin/trojan web:/usr/local/bin/trojan web -p 81:g' /etc/systemd/system/trojan-web.service
systemctl daemon-reload
systemctl restart trojan-web
yum install -y nginx
ln -s /usr/share/nginx/html /root/www
wget https://github.com/imzhucn/ubuntu_base/raw/master/web.zip -O web.zip
rm -rf /usr/share/nginx/html/index.html
unzip -o -d /usr/share/nginx/html /root/web.zip 
rm -rf web.zip
wget https://raw.githubusercontent.com/imzhucn/ubuntu_base/master/vps.html -O /usr/share/nginx/html/vps.html
sed -i "s:服务器名称:$biaoshi:g" /usr/share/nginx/html/vps.html
sed -i "s:服务器名称:$biaoshi:g" /usr/share/nginx/html/sp/index.html

yum install -y php php-fpm
sed -i "s/user = apache/user = nginx/g" /etc/php-fpm.d/www.conf
sed -i "s/group = apache/group = nginx/g" /etc/php-fpm.d/www.conf

wget https://raw.githubusercontent.com/imzhucn/ubuntu_base/master/nginx.conf -O /etc/nginx/nginx.conf


systemctl enable php-fpm
systemctl restart php-fpm
systemctl restart nginx


systemctl enable nginx.service
systemctl restart nginx
systemctl status nginx
wget https://github.com/imzhucn/ubuntu_base/raw/master/Clash.NET.x64.7z -O /usr/share/nginx/html/Clash.NET.x64.7z
wget https://github.com/Kr328/ClashForAndroid/releases/download/v2.4.14/cfa-2.4.14-premium-arm64-v8a-release.apk -O /usr/share/nginx/html/app-foss-arm64-v8a-release.apk
wget https://raw.githubusercontent.com/imzhucn/ubuntu_base/master/clash.yaml -O /usr/share/nginx/html/clash.yaml
wget https://raw.githubusercontent.com/imzhucn/ubuntu_base/master/clash.sh -O clash.sh && chmod +x clash.sh
wget https://download.visualstudio.microsoft.com/download/pr/78fa839b-2d86-4ece-9d97-5b9fe6fb66fa/10d406c0d247470daa80691d3b3460a6/windowsdesktop-runtime-5.0.10-win-x64.exe  -O /usr/share/nginx/html/net.exe
wget https://github.com/imzhucn/ubuntu_base/raw/master/tz.php -O /usr/share/nginx/html/tz.php
clear

##卸载阿里云盾
#echo && echo && echo
#echo -e "\033[1;32m 卸载阿里云盾 \033[0m"
#wget http://update.aegis.aliyun.com/download/uninstall.sh -O uninstall.sh && bash uninstall.sh && rm -rf uninstall.sh
#wget http://update.aegis.aliyun.com/download/quartz_uninstall.sh -O quartz_uninstall.sh && bash quartz_uninstall.sh && rm -rf quartz_uninstall.sh
#pkill aliyun-service
#rm -fr /etc/init.d/agentwatch /usr/sbin/aliyun-service
#rm -rf /usr/local/aegis*
#iptables -I INPUT -s 140.205.201.0/28 -j DROP
#iptables -I INPUT -s 140.205.201.16/29 -j DROP
#iptables -I INPUT -s 140.205.201.32/28 -j DROP
#iptables -I INPUT -s 140.205.225.192/29 -j DROP
#iptables -I INPUT -s 140.205.225.200/30 -j DROP
#iptables -I INPUT -s 140.205.225.184/29 -j DROP
#iptables -I INPUT -s 140.205.225.183/32 -j DROP
#iptables -I INPUT -s 140.205.225.206/32 -j DROP
#iptables -I INPUT -s 140.205.225.205/32 -j DROP
#iptables -I INPUT -s 140.205.225.195/32 -j DROP
#iptables -I INPUT -s 140.205.225.204/32 -j DROP
#rm -rf /usr/sbin/aliyun*
#chkconfig --del cloudmonitor

#clear

##开始安装BBR加速
echo && echo && echo
echo -e "\033[1;32m 开始安装BBR加速 \033[0m"
bash tcp.sh



