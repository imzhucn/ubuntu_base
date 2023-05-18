#!/usr/bin/env bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

#=================================================
#	Description: 小猪懒人脚本
#	Author: imzhu
#=================================================

sh_ver="1.0.13"
github="raw.githubusercontent.com/imzhucn/ubuntu_base/master"

Green_font_prefix="\033[32m" && Red_font_prefix="\033[31m" && Green_background_prefix="\033[42;37m" && Red_background_prefix="\033[41;37m" && Font_color_suffix="\033[0m"
Info="${Green_font_prefix}[信息]${Font_color_suffix}"
Error="${Red_font_prefix}[错误]${Font_color_suffix}"
Tip="${Green_font_prefix}[注意]${Font_color_suffix}"




dis_firewall(){
    ##关闭IPV6、防火墙
    echo && echo && echo
    echo -e "\033[1;32m 开BBR，关防火墙 \033[0m"
    ##echo "net.ipv6.conf.all.disable_ipv6=1" >>/etc/sysctl.conf
   ## echo "NETWORKING_IPV6=no" >>/etc/sysconfig/network
   ## sed -i 's/IPV6INIT="yes"/IPV6INIT="no"/g' /etc/sysconfig/network-scripts/ifcfg-eth0
  ##  sed -i 's/GRUB_CMDLINE_LINUX="net/GRUB_CMDLINE_LINUX="ipv6.disable=1 net/g' /etc/default/grub
    grub2-mkconfig -o /boot/grub2/grub.cfg
   ## systemctl disable ip6tables.service
    systemctl disable firewalld.service

    #开BBR，原版
    echo "net.core.default_qdisc=fq" >> /etc/sysctl.conf
    echo "net.ipv4.tcp_congestion_control=bbr" >> /etc/sysctl.conf
    sysctl -p
    #sleep 10
    
    ##装ZEROTIER
    curl -s https://install.zerotier.com/ | sudo bash
sudo systemctl enable zerotier-one.service
 sudo systemctl start zerotier-one.service
 sudo zerotier-cli join 233ccaac270e46c9
 
    
    
  start_menu
}

base_timezone(){
    ##基础环境构建
    echo && echo && echo
    #echo -e "\033[1;32m 基础环境构建 \033[0m"
   # rpm -ivh http://mirrors.wlnmp.com/centos/wlnmp-release-centos.noarch.rpm

    echo 'nameserver 8.8.8.8' >>/etc/resolv.conf 
    echo 'nameserver 8.8.4.4' >>/etc/resolv.conf 
    echo 'DNS=8.8.8.8'>> /etc/systemd/resolved.conf 
    echo 'DNS=8.8.4.4'>> /etc/systemd/resolved.conf
    #yum -y update
    yum -y install epel-release wntp certbot wget git libtool perl-core zlib-devel bzip2-devel python-devel openssl telnet curl xz-utils nload psmisc openssl-devel cmake
    yum -y groupinstall "Development Tools"

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

    wget https://raw.githubusercontent.com/helloxz/mping/master/mping.sh -O mping.sh && chmod +x mping.sh
    wget https://git.io/oneclick && chmod +x new-trojan.sh 
    wget https://git.io/trojan-install -O new-trojan.sh && chmod +x old-trojan.sh 
    wget https://git.io/trojan.txt -O trojan.txt
    echo "0秒后重启"
    #sleep 30
    reboot
  start_menu
}


install_frp(){
    ##安装FRP
    wget https://github.com/fatedier/frp/releases/download/v0.41.0/frp_0.41.0_linux_amd64.tar.gz -O frp_0.41.0_linux_amd64.tar.gz
    tar zxvf frp_*.tar.gz
    rm -rf .frp
    mv -f frp_0.*linux_amd64 .frp
    rm -rf frp_*.tar.gz
    rm -rf .frp/frpc*
    rm -rf .frp/frps_full.ini
    wget https://raw.githubusercontent.com/imzhucn/ubuntu_base/master/frps.sh -O frps.sh && chmod +x frps.sh
    wget https://raw.githubusercontent.com/imzhucn/ubuntu_base/master/frps.ini -O .frp/frps.ini
    wget https://raw.githubusercontent.com/imzhucn/ubuntu_base/master/frps.service -O /usr/lib/systemd/system/frps.service && chmod +x /usr/lib/systemd/system/frps.service

   

    systemctl daemon-reload
    systemctl enable frps
    
   # sleep 10
  start_menu
}


install_trojan_nginx(){
    ##安装trojan和nginx
    echo && echo && echo
    echo -e "\033[1;32m 开始安装trojan和nginx \033[0m"
    killall nginx
    bash /root/new-trojan.sh
    sed -i 's:/usr/local/bin/trojan web -p 81:/usr/local/bin/trojan web:g' /etc/systemd/system/trojan-web.service
    sed -i 's:/usr/local/bin/trojan web:/usr/local/bin/trojan web -p 81:g' /etc/systemd/system/trojan-web.service
    systemctl daemon-reload
    systemctl restart trojan-web
    mkdir /usr/share/nginx
    mkdir /usr/share/nginx/html
    ln -s /usr/share/nginx/html /root/www
    yum install -y nginx
    wget https://github.com/imzhucn/ubuntu_base/raw/master/web.zip -O web.zip
    rm -rf /usr/share/nginx/html/index.html
    unzip -o -d /usr/share/nginx/html /root/web.zip 
    rm -rf web.zip
    wget https://raw.githubusercontent.com/imzhucn/ubuntu_base/master/vps.html -O /usr/share/nginx/html/vps.html
   # sleep 10
  start_menu
}

install_php(){
    ##安装php
    yum install -y php php-fpm php-cli php-common php-devel php-gd php-pdo php-mysqlnd php-mbstring php-bcmath php-json
    sed -i "s/display_errors = Off/display_errors = On/g" /etc/php.ini
    sed -i "s/user = apache/user = nginx/g" /etc/php-fpm.d/www.conf
    sed -i "s/group = apache/group = nginx/g" /etc/php-fpm.d/www.conf
    mv /etc/nginx/nginx.conf /etc/nginx/nginx.conf.bak
    wget https://raw.githubusercontent.com/imzhucn/ubuntu_base/master/nginx.conf -O /etc/nginx/nginx.conf
  #  sleep 10
  start_menu
}

autorun_download(){
    ##设置软件自启动、下载文件
    systemctl restart php-fpm
    systemctl restart nginx
    systemctl enable php-fpm
    systemctl enable nginx.service
    wget https://github.com/Fndroid/clash_for_windows_pkg/releases/download/0.19.14/Clash.for.Windows-0.19.14-win.7z -O /usr/share/nginx/html/clash.7z
    wget https://github.com/Kr328/ClashForAndroid/releases/download/v2.5.5/cfa-2.5.5-premium-arm64-v8a-release.apk -O /usr/share/nginx/html/app-foss-arm64-v8a-release.apk
    wget https://github.com/2dust/v2rayNG/releases/download/1.8.5/v2rayNG_1.8.5.apk -O /usr/share/nginx/html/v2rayNG_1.8.5.apk
    wget https://raw.githubusercontent.com/imzhucn/ubuntu_base/master/clash.yaml -O /usr/share/nginx/html/clash.yaml
    wget https://raw.githubusercontent.com/imzhucn/ubuntu_base/master/clash.sh -O clash.sh && chmod +x clash.sh
    wget https://download.visualstudio.microsoft.com/download/pr/78fa839b-2d86-4ece-9d97-5b9fe6fb66fa/10d406c0d247470daa80691d3b3460a6/windowsdesktop-runtime-5.0.10-win-x64.exe  -O /usr/share/nginx/html/net.exe
    wget https://github.com/imzhucn/ubuntu_base/raw/master/tz.php -O /usr/share/nginx/html/tz.php
  #  sleep 10
  start_menu
}


change_pass(){
    ##改ROOT密码、服务器标识
    echo && echo && echo && echo && echo
    echo -e "\033[1;32m 改ROOT密码 \033[0m"
    echo -e "\033[1;32m 输入密码: \033[0m"
    read -p "输入密码:" pass 
    echo -e "\033[1;32m 服务器标识: \033[0m"
    read -p "服务器标识:" biaoshi
    echo root:$pass |sudo chpasswd root
    sudo sed -i 's/^#\?PermitRootLogin.*/PermitRootLogin yes/g' /etc/ssh/sshd_config;
    sudo sed -i 's/^#\?PasswordAuthentication.*/PasswordAuthentication yes/g' /etc/ssh/sshd_config;
    sudo service sshd restart
    sed -i "s:服务器名称:$biaoshi:g" /usr/share/nginx/html/vps.html
    sed -i "s:服务器名称:$biaoshi:g" /usr/share/nginx/html/sp/index.html
    
     sed -i "s/token = admin/token = $val/g" ~/.frp/frps.ini
    sed -i "s/dashboard_pwd = admin/dashboard_pwd = $val/g" ~/.frp/frps.ini
   # sleep 10
  start_menu
}

uninstall_aliyun(){
    ##卸载阿里云盾&甲骨文监控
    echo && echo && echo
    echo -e "\033[1;32m 卸载阿里云盾 \033[0m"
    yum remove -y osms-agent  oracle-cloud-agent
	systemctl disable osms-agent
	systemctl disable oracle-cloud-agent
	systemctl stop osms-agent
	systemctl stop oracle-cloud-agent
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
   # sleep 10
  start_menu
}


bbr(){
    ##安装BBR加速
    echo && echo && echo
    echo -e "\033[1;32m 开始安装BBR加速 \033[0m"
    read -p "警告！！！跟甲骨文不兼容！！确定安装输入520" tcp
    if [[$tcp == "520"]];then
    bash tcp.sh
    fi
	start_menu
}


#更新脚本
Update_Shell(){
	echo -e "当前版本为 [ ${sh_ver} ]，开始检测最新版本..."
	sh_new_ver=$(wget --no-check-certificate -qO- "http://git.io/imzhu.sh"|grep 'sh_ver="'|awk -F "=" '{print $NF}'|sed 's/\"//g'|head -1)
	[[ -z ${sh_new_ver} ]] && echo -e "${Error} 检测最新版本失败 !" && start_menu
	if [[ ${sh_new_ver} != ${sh_ver} ]]; then
		echo -e "发现新版本[ ${sh_new_ver} ]，是否更新？[Y/n]"
		read -p "(默认: y):" yn
		[[ -z "${yn}" ]] && yn="y"
		if [[ ${yn} == [Yy] ]]; then
			wget -N --no-check-certificate http://git.io/imzhu.sh -O imzhu.sh && chmod +x imzhu.sh 
			echo -e "脚本已更新为最新版本[ ${sh_new_ver} ] !" && exit
		else
			echo && echo "	已取消..." && echo
		fi
	else
		echo -e "当前已是最新版本[ ${sh_new_ver} ] ，无需升级!"
		#sleep 5s
		start_menu
	fi
	
	
}


#检查系统
syscheck(){
    if [[ -f /etc/redhat-release ]]; then
                release="centos"
        elif cat /etc/issue | grep -q -E -i "debian"; then
                release="debian"
        elif cat /etc/issue | grep -q -E -i "ubuntu"; then
                release="ubuntu"
        elif cat /etc/issue | grep -q -E -i "centos|red hat|redhat"; then
                release="centos"
        elif cat /proc/version | grep -q -E -i "debian"; then
                release="debian"
        elif cat /proc/version | grep -q -E -i "ubuntu"; then
                release="ubuntu"
        elif cat /proc/version | grep -q -E -i "centos|red hat|redhat"; then
                release="centos"
    fi

    if [[ -s /etc/redhat-release ]]; then
            version=`grep -oE  "[0-9.]+" /etc/redhat-release | cut -d . -f 1`
    else
            version=`grep -oE  "[0-9.]+" /etc/issue | cut -d . -f 1`
    fi

    bit=`uname -m`
    if [[ ${bit} = "x86_64" ]]; then
            bit="x64"
    else
            bit="x32"
    fi
    
#   echo ${release} $version $bit

}

#开始菜单
start_menu(){
#clear

echo && echo -e " imzhu.sh 懒人脚本 

  

 ${Green_font_prefix}0.${Font_color_suffix} 更新脚本
 ${Green_font_prefix}1.${Font_color_suffix} 开BBR、关防火墙、装ZEROTIER
 ${Green_font_prefix}2.${Font_color_suffix} 基础环境构建、修改时区 
 ${Green_font_prefix}3.${Font_color_suffix} 安装FRP
 ${Green_font_prefix}4.${Font_color_suffix} 安装trojan和nginx
 ${Green_font_prefix}5.${Font_color_suffix} 安装php（不完善）
 ${Green_font_prefix}6.${Font_color_suffix} 设置软件自启动、下载文件
 ${Green_font_prefix}7.${Font_color_suffix} 改ROOT密码、服务器标识
 ${Green_font_prefix}8.${Font_color_suffix} 卸载阿里云盾
 ${Green_font_prefix}9.${Font_color_suffix} 单独安装BBR加速（警告！别乱点）
 ${Green_font_prefix}10.${Font_color_suffix} 退出脚本
————————————————————————————————" && echo
echo $sh_ver
syscheck
	echo -e ${Tip} ${release} $version $bit ${Tip} ${Font_color_suffix}
	
echo
read -p " 请输入数字 [0-11]:" num
case "$num" in
	0)
	Update_Shell
	;;
	1)
	dis_firewall
	;;
	2)
	base_timezone
	;;
	3)
	install_frp
	;;
	4)
	install_trojan_nginx
	;;
	5)
	install_php
	;;
	6)
	autorun_download
	;;
	7)
	change_pass
	;;
	8)
	uninstall_aliyun
	;;
	9)
	bbr
	;;
	10)
	exit 1
	;;
	11)
	exit 1
	;;
	*)
	clear
	echo -e "${Error}:请输入正确数字 [0-10]"
	sleep 5s
	start_menu
	;;
esac
}


start_menu
