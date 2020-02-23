apt-get -y install wget curl xz-utils nload
sed -i 's/PermitRootLogin no/PermitRootLogin yes/g' /etc/ssh/sshd_config
sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
service sshd restart
echo root:admin|chpasswd
echo "alias ls='ls --color'" >>~/.bashrc
echo "alias ll='ls -l --color=auto'" >>~/.bashrc
echo "alias grep='grep --color=auto'" >>~/.bashrc
source ~/.bashrc
wget -N --no-check-certificate "https://raw.githubusercontent.com/chiakge/Linux-NetSpeed/master/tcp.sh" && chmod +x tcp.sh 
wget --no-check-certificate https://git.io/v2ray.sh && chmod +x v2ray.sh 
wget --no-check-certificate https://github.com/V2RaySSR/Trojan/raw/master/Trojan.sh && chmod +x Trojan.sh 
ls -l --color=auto
passwd
