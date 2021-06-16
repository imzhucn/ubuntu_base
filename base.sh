#yum -y update

apt-get -y install wget curl xz-utils nload
yum install -y wget curl xz-utils nload
yum install -y psmisc
sed -i 's/PermitRootLogin no/PermitRootLogin yes/g' /etc/ssh/sshd_config
sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
service sshd restart
#echo 'wget -qO- sb.oldking.net | bash' >speedtest.sh   && chmod +x speedtest.sh
echo root:admin|chpasswd
echo "alias ls='ls --color'" >>~/.bashrc
echo "alias ll='ls -la --color=auto'" >>~/.bashrc
echo "alias grep='grep --color=auto'" >>~/.bashrc
source ~/.bashrc
wget -N --no-check-certificate "https://raw.githubusercontent.com/chiakge/Linux-NetSpeed/master/tcp.sh" && chmod +x tcp.sh 
wget --no-check-certificate https://github.com/V2RaySSR/Trojan/raw/master/Trojan.sh && chmod +x Trojan.sh 
mv -f Trojan.sh old-trojan.sh
wget --no-check-certificate https://git.io/trojan-install  && chmod +x trojan-install 
mv -f trojan-install new-trojan.sh
wget --no-check-certificate https://git.io/trojan.txt

ls -l --color=auto
ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
ntpdate time.windows.com
hwclock --systohc

wget https://github.com/fatedier/frp/releases/download/v0.37.0/frp_0.37.0_linux_amd64.tar.gz
tar zxvf frp_*.tar.gz
mv -f frp_0.*linux_amd64 .frp
rm -rf frp_*.tar.gz
rm -rf .frp/frpc*
rm -rf .frp/frps_full.ini


wget --no-check-certificate https://raw.githubusercontent.com/imzhucn/ubuntu_base/master/frps.sh && chmod +x frps.sh
wget --no-check-certificate https://raw.githubusercontent.com/imzhucn/ubuntu_base/master/frps.ini
mv -f frps.ini .frp/frps.ini
wget --no-check-certificate https://raw.githubusercontent.com/imzhucn/ubuntu_base/master/frps.service && chmod +x frps.service
mv -f frps.service /usr/lib/systemd/system/frps.service
systemctl daemon-reload
systemctl enable frps
#vim .frp/frps.ini


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


#yum -y remove openssl openssl-devel cmake
#yum -y install epel-release
#yum -y groupinstall "Development Tools"
#yum -y install certbot wget git libtool perl-core zlib-devel bzip2-devel python-devel openssl
#echo "acme.sh --set-default-ca --server letsencrypt" > ~/acme.sh && chmod +x acme.sh && bash acme.sh


#password
read -p "输入密码:" val echo $val
echo root:$val|chpasswd
sed -i "s/token = admin/token = $val/g" ~/.frp/frps.ini
sed -i "s/dashboard_pwd = admin/dashboard_pwd = $val/g" ~/.frp/frps.ini

bash /root/new-trojan.sh
sed -i 's:/usr/local/bin/trojan web -p 81:/usr/local/bin/trojan web:g' /etc/systemd/system/trojan-web.service
sed -i 's:/usr/local/bin/trojan web:/usr/local/bin/trojan web -p 81:g' /etc/systemd/system/trojan-web.service
systemctl daemon-reload
systemctl restart trojan-web
yum install -y nginx
ln -s /usr/share/nginx/html /root/www
wget https://github.com/imzhucn/ubuntu_base/raw/master/web.zip
rm -rf /usr/share/nginx/html/index.html
unzip -d /usr/share/nginx/html /root/web.zip
#mv -f /usr/share/nginx/html /usr/share/nginx/html_old
#mv -f web/* /usr/share/nginx/html/
systemctl enable nginx.service
systemctl restart nginx
systemctl status nginx
mkdir /usr/share/nginx/html/ariang
wget https://github.com/mayswind/AriaNg/releases/download/1.2.2/AriaNg-1.2.2-AllInOne.zip
unzip -d /usr/share/nginx/html/ariang /root/AriaNg-1.2.2-AllInOne.zip

echo "1" |bash /root/tcp.sh



