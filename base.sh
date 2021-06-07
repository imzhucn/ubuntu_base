apt-get -y install wget curl xz-utils nload
yum install -y wget curl xz-utils nload
sed -i 's/PermitRootLogin no/PermitRootLogin yes/g' /etc/ssh/sshd_config
sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
service sshd restart
echo root:admin|chpasswd
echo "alias ls='ls --color'" >>~/.bashrc
echo "alias ll='ls -l --color=auto'" >>~/.bashrc
echo "alias grep='grep --color=auto'" >>~/.bashrc
source ~/.bashrc
wget -N --no-check-certificate "https://raw.githubusercontent.com/chiakge/Linux-NetSpeed/master/tcp.sh" && chmod +x tcp.sh 
wget --no-check-certificate https://github.com/V2RaySSR/Trojan/raw/master/Trojan.sh && chmod +x Trojan.sh 
mv Trojan.sh old-trojan.sh
wget --no-check-certificate https://git.io/trojan-install  && chmod +x trojan-install 
mv trojan-install new-trojan.sh
ls -l --color=auto
ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
ntpdate time.windows.com
hwclock --systohc
passwd


