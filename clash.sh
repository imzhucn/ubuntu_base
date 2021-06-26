if [ -f hostname.txt ] ; then
wangzhi=$(cat hostname.txt)
echo -e "\n\n 默认网址为：$wangzhi \n 请确认是否正确 \n\n"

else
echo -e "\n hostname文件不存在 \n\n"
sleep 2
read -p "输入网址:" wangzhi
echo $wangzhi > hostname.txt

fi

read -p "输入名称和密码:" mima


cp -rf /usr/share/nginx/html/clash.yaml "/usr/share/nginx/html/$mima.yaml"
sed -i "s/mimamima/$mima/g" "/usr/share/nginx/html/$mima.yaml"
sed -i "s/wangzhiwangzhi/$wangzhi/g" "/usr/share/nginx/html/$mima.yaml"
echo -e "\n\n 链接："
echo -e "http://$wangzhi/$mima.yaml \n\n"

