#!/bin/bash

# =====================
# 配置参数
# =====================

##配置IP
sed -i "s/192.168.6.1/$LAN/g" package/base-files/files/bin/config_generate

# 加入作者信息
sed -i "s/DISTRIB_DESCRIPTION='*.*'/DISTRIB_DESCRIPTION='OpenWrt-$(date +%Y%m%d)'/g"  package/base-files/files/etc/openwrt_release
sed -i "s/DISTRIB_REVISION='*.*'/DISTRIB_REVISION=' By grandway2025'/g" package/base-files/files/etc/openwrt_release
sed -i "s|^OPENWRT_RELEASE=\".*\"|OPENWRT_RELEASE=\"OpenWrt定制版 \"|" package/base-files/files/usr/lib/os-release

# 删除旧主题
rm -rf feeds/luci/themes/luci-theme-argon

# argon
git clone https://github.com/jerrykuku/luci-theme-argon.git package/new/luci-theme-argon
curl -s https://github.com/grandway2025/Actions-OpenWrt/Customize/argon/bg1.jpg  > package/new/luci-theme-argon/htdocs/luci-static/argon/img/bg1.jpg

# 主题设置
sed -i 's|<a class="luci-link" href="https://github.com/openwrt/luci" target="_blank">Powered by <%= ver.luciname %> (<%= ver.luciversion %>)</a>|<a class="luci-link" href="https://github.com/grandway2025" target="_blank">OpenWrt定制版</a>|g' package/new/luci-theme-argon/luasrc/view/themes/argon/footer_login.htm

##WiFi
# sed -i "s/MT7986_AX6000_2.4G/OpenWrt-2.4G/g" package/mtk/drivers/wifi-profile/files/mt7986/mt7986-ax6000.dbdc.b0.dat
# sed -i "s/MT7986_AX6000_5G/OpenWrt-5G/g" package/mtk/drivers/wifi-profile/files/mt7986/mt7986-ax6000.dbdc.b1.dat

##New WiFi
# sed -i "s/ImmortalWrt-2.4G/OpenWrt-2.4G/g" package/mtk/applications/mtwifi-cfg/files/mtwifi.sh
# sed -i "s/ImmortalWrt-5G/OpenWrt-5G/g" package/mtk/applications/mtwifi-cfg/files/mtwifi.sh

# 删除软件依赖
rm -rf feeds/packages/net/chinadns-ng 
rm -rf feeds/packages/net/hysteria 
rm -rf feeds/packages/net/mosdns
rm -rf feeds/packages/net/shadowsocksr-libev
rm -rf feeds/packages/net/shadowsocks-rust 
rm -rf feeds/packages/net/shadowsocks-libev 
rm -rf feeds/packages/net/tcping 
rm -rf feeds/packages/net/trojan
rm -rf feeds/packages/net/trojan-plus
rm -rf feeds/packages/net/tuic-client  
rm -rf feeds/packages/net/v2ray-core  
rm -rf feeds/packages/net/v2ray-plugin
rm -rf feeds/packages/net/xray-core 
rm -rf feeds/packages/net/xray-plugin
rm -rf feeds/packages/net/v2ray-geodata
rm -rf feeds/packages/net/open-app-filter
rm -rf feeds/packages/net/mosdns
rm -rf feeds/packages/net/lucky
rm -rf feeds/packages/net/ddns-go
rm -rf feeds/packages/utils/v2dat
rm -rf feeds/packages/lang/golang
 
# 删除软件包
rm -rf feeds/luci/applications/luci-app-passwall
rm -rf feeds/luci/applications/luci-app-passwall2
rm -rf feeds/luci/applications/luci-app-ssr-plus
rm -rf feeds/luci/applications/luci-app-vssr
rm -rf feeds/luci/applications/luci-app-appfilter
rm -rf feeds/luci/applications/luci-app-ddns-go
rm -rf feeds/luci/applications/luci-app-openclash
rm -rf feeds/luci/applications/luci-app-lucky
rm -rf feeds/luci/applications/luci-app-mosdns
rm -rf feeds/luci/applications/luci-app-alist

#添加额外软件包
# golang 1.24
rm -rf feeds/packages/lang/golang
git clone https://github.com/sbwml/packages_lang_golang -b 25.x feeds/packages/lang/golang

# SSRP & Passwall
rm -rf feeds/packages/net/{xray-core,v2ray-core,v2ray-geodata,sing-box}
git clone -b openwrt-24.10 https://git.kejizero.online/zhao/openwrt_helloworld package/new/helloworld

# lucky
git clone https://github.com/gdy666/luci-app-lucky.git package/new/lucky

# Mosdns
git clone https://github.com/sbwml/luci-app-mosdns -b v5 package/new/mosdns
cp -r package/new/mosdns/{luci-app-mosdns,mosdns,v2dat} package/new/helloworld
rm -rf package/new/mosdns

# OpenAppFilter
git clone https://github.com/destan19/OpenAppFilter package/new/OpenAppFilter

# luci-app-taskplan
git clone https://github.com/sirpdboy/luci-app-taskplan package/new/luci-app-taskplan

# luci-app-webdav
git clone -b openwrt-24.10 https://github.com/sbwml/luci-app-webdav.git package/new/luci-app-webdav

# adguardhome
git clone https://git.kejizero.online/zhao/luci-app-adguardhome package/new/luci-app-adguardhome

# Docker
rm -rf feeds/luci/applications/luci-app-dockerman
git clone https://git.kejizero.online/zhao/luci-app-dockerman -b openwrt-24.10 feeds/luci/applications/luci-app-dockerman
rm -rf feeds/packages/utils/{docker,dockerd,containerd,runc}
git clone https://git.kejizero.online/zhao/packages_utils_docker feeds/packages/utils/docker
git clone https://git.kejizero.online/zhao/packages_utils_dockerd feeds/packages/utils/dockerd
git clone https://git.kejizero.online/zhao/packages_utils_containerd feeds/packages/utils/containerd
git clone https://git.kejizero.online/zhao/packages_utils_runc feeds/packages/utils/runc

# 更新feeds 
./scripts/feeds update -a && ./scripts/feeds install -a
