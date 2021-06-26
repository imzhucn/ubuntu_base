clear

##改ROOT密码
echo && echo && echo && echo && echo
echo -e "\033[1;32m 改ROOT密码 \033[0m"
echo -e "\033[1;32m 输入密码: \033[0m"
read -p "输入密码:" val echo $val
echo root:$val|chpasswd

clear

##基础环境构建
echo && echo && echo
echo -e "\033[1;32m 基础环境构建 \033[0m"
#yum -y update
#yum -y remove openssl openssl-devel cmake
yum -y install epel-release
yum -y groupinstall "Development Tools"
yum -y install certbot wget git libtool perl-core zlib-devel bzip2-devel python-devel openssl
apt-get -y install wget curl xz-utils nload
yum install -y wget curl xz-utils nload
yum install -y psmisc
sed -i 's/PermitRootLogin no/PermitRootLogin yes/g' /etc/ssh/sshd_config
sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
service sshd restart
echo "alias ls='ls --color'" >>~/.bashrc
echo "alias ll='ls -la --color=auto'" >>~/.bashrc
echo "alias grep='grep --color=auto'" >>~/.bashrc
source ~/.bashrc
ls -l --color=auto
ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
ntpdate time.windows.com
hwclock --systohc

clear

##下载相关文件
echo && echo && echo
echo -e "\033[1;32m 下载相关文件 \033[0m"
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
#echo -e "\033[1;32m 改密码前 \033[0m"
#cat ~/.frp/frps.ini
#sleep 10
sed -i "s/token = admin/token = $val/g" ~/.frp/frps.ini
sed -i "s/dashboard_pwd = admin/dashboard_pwd = $val/g" ~/.frp/frps.ini
#sleep 3
#echo -e "\033[1;32m 改密码后 \033[0m"
#cat ~/.frp/frps.ini
#sleep 30
systemctl daemon-reload
systemctl enable frps

clear

##开始安装trojan和nginx
echo && echo && echo
echo -e "\033[1;32m 开始安装trojan和nginx \033[0m"
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
systemctl enable nginx.service
systemctl restart nginx
systemctl status nginx
wget https://github.com/Fndroid/clash_for_windows_pkg/releases/download/0.15.10/Clash.for.Windows-0.15.10-win.7z -O /usr/share/nginx/html/Clash.for.Windows-0.15.10-win.7z
wget https://github.com/Kr328/ClashForAndroid/releases/download/v2.3.22/app-arm64-v8a-release.apk -O /usr/share/nginx/html/app-arm64-v8a-release.apk
wget https://github.com/Kr328/ClashForAndroid/releases/download/v2.3.22/app-armeabi-v7a-release.apk -O /usr/share/nginx/html/app-armeabi-v7a-release.apk
wget https://raw.githubusercontent.com/imzhucn/ubuntu_base/master/clash.yaml -O /usr/share/nginx/html/clash.yaml
wget https://raw.githubusercontent.com/imzhucn/ubuntu_base/master/clash.sh -O clash.sh && chmod +x clash.sh

clear

##卸载阿里云盾
echo && echo && echo
echo -e "\033[1;32m 卸载阿里云盾 \033[0m"
wget http://update.aegis.aliyun.com/download/uninstall.sh -O uninstall.sh && bash uninstall.sh && rm -rf uninstall.sh
wget http://update.aegis.aliyun.com/download/quartz_uninstall.sh -O quartz_uninstall.sh && bash quartz_uninstall.sh && rm -rf quartz_uninstall.sh
pkill aliyun-service
rm -fr /etc/init.d/agentwatch /usr/sbin/aliyun-service
rm -rf /usr/local/aegis*
iptables -I INPUT -s 140.205.201.0/28 -j DROP
iptables -I INPUT -s 140.205.201.16/29 -j DROP
iptables -I INPUT -s 140.205.201.32/28 -j DROP
iptables -I INPUT -s 140.205.225.192/29 -j DROP
iptables -I INPUT -s 140.205.225.200/30 -j DROP
iptables -I INPUT -s 140.205.225.184/29 -j DROP
iptables -I INPUT -s 140.205.225.183/32 -j DROP
iptables -I INPUT -s 140.205.225.206/32 -j DROP
iptables -I INPUT -s 140.205.225.205/32 -j DROP
iptables -I INPUT -s 140.205.225.195/32 -j DROP
iptables -I INPUT -s 140.205.225.204/32 -j DROP
rm -rf /usr/sbin/aliyun*
chkconfig --del cloudmonitor

clear

##开始安装BBR加速
echo && echo && echo
echo -e "\033[1;32m 开始安装BBR加速 \033[0m"
echo "1" |bash tcp.sh



