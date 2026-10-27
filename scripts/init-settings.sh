#!/bin/bash

#更改默认地址为192.168.4.100
DEF_IP="192.168.4.100"
#修改immortalwrt.lan关联IP
sed -i "s/192\.168\.[0-9]*\.[0-9]*/$DEF_IP/g" $(find ./feeds/luci/modules/luci-mod-system/ -type f -name "flash.js")
sed -i "s/192\.168\.[0-9]*\.[0-9]*/$DEF_IP/g" package/base-files/files/bin/config_generate



echo "========================================"
echo "homeproxy 处理完成！"
echo "初始化设置执行成功!"
