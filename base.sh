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
echo 'wget -qO- sb.oldking.net | bash' >speedtest.sh   && chmod +x speedtest.sh
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
vim .frp/frps.ini

passwd

./tcp.sh

