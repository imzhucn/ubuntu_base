read -p "输入名称和密码:" mima
#echo $mima
read -p "输入网址:" wangzhi
cp /usr/share/nginx/html/clash.yaml "/usr/share/nginx/html/$mima.yaml"
sed -i "s/mimamima/$mima/g" "/usr/share/nginx/html/$mima.yaml"
sed -i "s/wangzhiwangzhi/$wangzhi/g" "/usr/share/nginx/html/$mima.yaml"
echo http://$wangzhi/$mima.yaml
