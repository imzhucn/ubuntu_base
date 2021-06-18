echo && echo && echo && echo && echo
echo -e "\033[1;32m 输入密码: \033[0m"
read -p "输入密码:" val echo $val
echo root:admin|chpasswd

##基础环境构建
echo && echo && echo
echo -e "\033[1;32m 基础环境构建 \033[0m"
#yum -y update
yum -y remove openssl openssl-devel cmake
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

##下载相关文件
echo && echo && echo
echo -e "\033[1;32m 下载相关文件 \033[0m"
wget -N --no-check-certificate "https://raw.githubusercontent.com/chiakge/Linux-NetSpeed/master/tcp.sh" && chmod +x tcp.sh 
wget --no-check-certificate https://github.com/V2RaySSR/Trojan/raw/master/Trojan.sh && chmod +x Trojan.sh 
mv -f Trojan.sh old-trojan.sh
wget --no-check-certificate https://git.io/trojan-install  && chmod +x trojan-install 
mv -f trojan-install new-trojan.sh
wget --no-check-certificate https://git.io/trojan.txt -O trojan.txt
wget https://github.com/fatedier/frp/releases/download/v0.37.0/frp_0.37.0_linux_amd64.tar.gz -O frp_0.37.0_linux_amd64.tar.gz
tar zxvf frp_*.tar.gz
mv -f frp_0.*linux_amd64 .frp
rm -rf frp_*.tar.gz
rm -rf .frp/frpc*
rm -rf .frp/frps_full.ini
sed -i "s/token = admin/token = $val/g" ~/.frp/frps.ini
sed -i "s/dashboard_pwd = admin/dashboard_pwd = $val/g" ~/.frp/frps.ini
wget --no-check-certificate https://raw.githubusercontent.com/imzhucn/ubuntu_base/master/frps.sh -O frps.sh && chmod +x frps.sh
wget --no-check-certificate https://raw.githubusercontent.com/imzhucn/ubuntu_base/master/frps.ini -O .frp/frps.ini
wget --no-check-certificate https://raw.githubusercontent.com/imzhucn/ubuntu_base/master/frps.service -O /usr/lib/systemd/system/frps.service && chmod +x /usr/lib/systemd/system/frps.service
#mv -f frps.service /usr/lib/systemd/system/frps.service
systemctl daemon-reload
systemctl enable frps



#sed -i 's:/usr/local/bin/trojan web -p 81:/usr/local/bin/trojan web:g' /etc/systemd/system/trojan-web.service
#sed -i 's:/usr/local/bin/trojan web -p 81:/usr/local/bin/trojan web:g' /etc/systemd/system/trojan-web.service
#sed -i 's:/usr/local/bin/trojan web -p 81:/usr/local/bin/trojan web:g' /etc/systemd/system/trojan-web.service
#sed -i 's:/usr/local/bin/trojan web:/usr/local/bin/trojan web -p 81:g' /etc/systemd/system/trojan-web.service
#systemctl daemon-reload
#systemctl restart trojan-web

#yum install -y nginx

#sed -i 's:/usr/share/nginx/html:/root/www:g' /etc/nginx/nginx.conf
#wget https://github.com/imzhucn/ubuntu_base/raw/master/web.zip
#unzip web.zip
#mv -f /usr/share/nginx/html /usr/share/nginx/html_old
#mv -f web /usr/share/nginx/html
#systemctl enable nginx.service
#systemctl restart nginx
#systemctl status nginx



##改ROOT密码
echo && echo && echo
echo -e "\033[1;32m 改ROOT密码 \033[0m"
#read -p "输入密码:" val echo $val
echo root:$val|chpasswd



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
unzip -d /usr/share/nginx/html /root/web.zip 
rm -rf web.zip
systemctl enable nginx.service
systemctl restart nginx
systemctl status nginx


##卸载阿里云盾
echo && echo && echo
echo -e "\033[1;32m 卸载阿里云盾 \033[0m"
wget http://update.aegis.aliyun.com/download/uninstall.sh &&bash uninstall.sh && rm -rf uninstall.sh
wget http://update.aegis.aliyun.com/download/quartz_uninstall.sh && bash quartz_uninstall.sh && rm -rf quartz_uninstall.sh
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


##开始安装BBR加速
echo && echo && echo
echo -e "\033[1;32m 开始安装BBR加速 \033[0m"
echo "1" |bash tcp.sh



