#!/bin/bash
set -x
#删除feeds中的插件
rm -rf feeds/packages/lang/golang
rm -rf feeds/packages/net/{geoview,chinadns-ng,hysteria,mosdns,v2ray-geodata}
rm -rf feeds/packages/net/{shadowsocks-libev,shadowsocks-rust,shadowsocksr-libev}
rm -rf feeds/packages/net/{sing-box,v2ray-geodata,v2ray-plugin,xray-core}
rm -rf feeds/luci/applications/{luci-app-mosdns,luci-app-passwall}

#克隆依赖插件
git clone --depth 1 https://github.com/Openwrt-Passwall/openwrt-passwall-packages.git package/pwpage
git clone --depth 1 https://github.com/sbwml/packages_lang_golang -b 27.x feeds/packages/lang/golang
git clone --depth 1 https://github.com/acmel/dwarves -b v1.30 feeds/packages/dwarves                      #for vmlinux-btf依赖

#克隆的源码放在small文件夹
mkdir package/small
pushd package/small
pwd
ls -lah

# luci-theme-aurora
git clone -b master --depth 1 https://github.com/eamonxg/luci-theme-aurora.git

# luci-app-nft-timecontrol
git clone -b main --depth 1 https://github.com/sirpdboy/luci-app-timecontrol.git

# adguardhome
# git clone -b main --depth 1 https://github.com/XiaoBinin/luci-app-adguardhome.git

# lucky
git clone -b main --depth 1 https://github.com/gdy666/luci-app-lucky.git

# smartdns
# git clone -b master --depth 1 https://github.com/pymumu/luci-app-smartdns.git
# git clone -b master --depth 1 https://github.com/pymumu/smartdns.git

# ssrp
# git clone -b master --depth 1 https://github.com/fw876/helloworld.git

# VIKINGYFY/packages
git clone -b main --depth 1 https://github.com/VIKINGYFY/packages.git

# passwall
git clone -b main --depth 1 https://github.com/Openwrt-Passwall/openwrt-passwall.git

# passwall2
git clone -b main --depth 1 https://github.com/Openwrt-Passwall/openwrt-passwall2.git

# mosdns
git clone -b v5 --depth 1 https://github.com/sbwml/luci-app-mosdns.git

# luci-app-netspeedtest
git clone -b master --depth 1 https://github.com/muink/luci-app-netspeedtest.git

# openclash
# git clone -b master --depth 1 https://github.com/vernesong/OpenClash.git

# OpenWrt-nikki
git clone -b main --depth 1 https://github.com/nikkinikki-org/OpenWrt-nikki.git

# OpenWrt-momo
git clone -b main --depth 1 https://github.com/nikkinikki-org/OpenWrt-momo.git

# daed
git clone -b kix --depth 1 https://github.com/QiuSimons/luci-app-daed.git
git clone -b kix --depth 1 https://github.com/QiuSimons/luci-app-dae.git
git clone -b master --depth 1 https://github.com/QiuSimons/vmlinux-btf.git       #for dae
git clone -b master --depth 1 https://github.com/QiuSimons/luci-app-honk.git     #for honk 20261031

# nikki
git clone -b main --depth 1 https://github.com/nikkinikki-org/OpenWrt-nikki.git

popd
pwd
ls -lah

function git_sparse_clone() {
 branch="$1" repourl="$2" && shift 2
 git clone --depth=1 -b $branch --single-branch --filter=blob:none --sparse $repourl
 repodir=$(echo $repourl | awk -F '/' '{print $(NF)}')
 cd $repodir && git sparse-checkout set $@
 mv -f $@ ../package/small
 cd .. && rm -rf $repodir
}

#adguardhome
git_sparse_clone main https://github.com/kenzok8/small-package luci-app-adguardhome  # 核查有260909

# store
git_sparse_clone main https://github.com/kenzok8/small-package luci-app-store
git_sparse_clone main https://github.com/kenzok8/small-package luci-lib-taskd
git_sparse_clone main https://github.com/kenzok8/small-package luci-lib-xterm
git_sparse_clone main https://github.com/kenzok8/small-package taskd

#更换store插件名称
sed -i 's/("iStore"),/("软件仓库"),/g' package/small/luci-app-store/luasrc/controller/store.lua



echo "packages executed successfully!"
