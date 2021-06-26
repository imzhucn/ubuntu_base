clear

if [ -f hostname.txt ] ; then
wangzhi=$(cat hostname.txt)

echo -e "\n\n 默认网址为：$wangzhi "
echo -e "\033[1;32m \n 请确认是否正确 \n\n \033[0m"
else
echo -e "\033[1;32m 文件不存在 \033[0m"
read -p "输入网址:" wangzhi
echo $wangzhi > hostname.txt

fi

read -p "输入名称和密码:" mima


cp -rf /usr/share/nginx/html/clash.yaml "/usr/share/nginx/html/$mima.yaml"
sed -i "s/mimamima/$mima/g" "/usr/share/nginx/html/$mima.yaml"
sed -i "s/wangzhiwangzhi/$wangzhi/g" "/usr/share/nginx/html/$mima.yaml"
sed -i "s/imzhu.vip/$wangzhi/g" "/usr/share/nginx/html/$mima.yaml"
echo -e "\n\n 链接："
echo -e "http://$wangzhi/$mima.yaml \n\n"

