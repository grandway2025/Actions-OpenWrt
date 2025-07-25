#!/bin/bash

# =====================
# 配置参数
# =====================

##配置IP
sed -i "s/192.168.6.1/$LAN/g" package/base-files/files/bin/config_generate

# default name
sed -i 's/ImmortalWrt/OpenWrt/' package/base-files/files/bin/config_generate

# 删除软件依赖
rm -rf feeds/packages/net/{v2ray-geodata,open-app-filter,shadowsocksr-libev,shadowsocks-rust,shadowsocks-libev}
rm -rf feeds/packages/net/{tcping,trojan,trojan-plus,tuic-client,v2ray-core,v2ray-plugin,xray-core,xray-plugin,sing-box}
rm -rf feeds/packages/net/{chinadns-ng,hysteria,mosdns,lucky,ddns-go,v2dat,golang}

# 删除软件包
rm -rf feeds/luci/applications/{luci-app-daed,luci-app-dae,luci-app-homeproxy,luci-app-openclash}
rm -rf feeds/luci/applications/{luci-app-passwall,luci-app-passwall2,luci-app-ssr-plus,luci-app-vssr}
rm -rf feeds/luci/applications/{luci-app-appfilter,luci-app-ddns-go,luci-app-lucky,luci-app-mosdns,luci-app-alist,luci-app-openlist}

# 加入作者信息
sed -i "s/DISTRIB_DESCRIPTION='*.*'/DISTRIB_DESCRIPTION='OpenWrt-$(date +%Y%m%d)'/g"  package/base-files/files/etc/openwrt_release
sed -i "s/DISTRIB_REVISION='*.*'/DISTRIB_REVISION=' By grandway2025'/g" package/base-files/files/etc/openwrt_release
sed -i "s|^OPENWRT_RELEASE=\".*\"|OPENWRT_RELEASE=\"OpenWrt定制版 \"|" package/base-files/files/usr/lib/os-release

# argon
rm -rf feeds/luci/themes/luci-theme-argon
git clone https://github.com/jerrykuku/luci-theme-argon.git package/new/luci-theme-argon
curl -s https://raw.githubusercontent.com/grandway2025/Actions-OpenWrt/main/Customize/Mediatek/argon/bg1.jpg  > package/new/luci-theme-argon/htdocs/luci-static/argon/img/bg1.jpg
curl -s https://raw.githubusercontent.com/grandway2025/Actions-OpenWrt/main/Customize/Mediatek/argon/iconfont.ttf > package/new/luci-theme-argon/htdocs/luci-static/argon/fonts/iconfont.ttf
curl -s https://raw.githubusercontent.com/grandway2025/Actions-OpenWrt/main/Customize/Mediatek/argon/iconfont.woff > package/new/luci-theme-argon/htdocs/luci-static/argon/fonts/iconfont.woff
curl -s https://raw.githubusercontent.com/grandway2025/Actions-OpenWrt/main/Customize/Mediatek/argon/iconfont.woff2 > package/new/luci-theme-argon/htdocs/luci-static/argon/fonts/iconfont.woff2
curl -s https://raw.githubusercontent.com/grandway2025/Actions-OpenWrt/main/Customize/Mediatek/argon/cascade.css > package/new/luci-theme-argon/htdocs/luci-static/argon/css/cascade.css

# argon-config
rm -rf feeds/luci/applications/luci-app-argon-config
git clone https://github.com/jerrykuku/luci-app-argon-config.git package/new/luci-app-argon-config
sed -i "s/bing/none/g" package/new/luci-app-argon-config/root/etc/config/argon

# kucat
git clone https://github.com/sirpdboy/luci-theme-kucat package/new/kucat
# curl -s https://raw.githubusercontent.com/grandway2025/Actions-OpenWrt/main/Customize/Mediatek/kucat/bg1.jpg > package/new/kucat/luci-theme-kucat/htdocs/luci-static/kucat/img/bg1.jpg
curl -s https://raw.githubusercontent.com/grandway2025/Actions-OpenWrt/main/Customize/Mediatek/kucat/jnaiconfont.ttf > package/new/kucat/luci-theme-kucat/htdocs/luci-static/kucat/fonts/jnaiconfont.ttf
curl -s https://raw.githubusercontent.com/grandway2025/Actions-OpenWrt/main/Customize/Mediatek/kucat/jnaiconfont.woff > package/new/kucat/luci-theme-kucat/htdocs/luci-static/kucat/fonts/jnaiconfont.woff
curl -s https://raw.githubusercontent.com/grandway2025/Actions-OpenWrt/main/Customize/Mediatek/kucat/jnaiconfont.woff2 > package/new/kucat/luci-theme-kucat/htdocs/luci-static/kucat/fonts/jnaiconfont.woff2
curl -s https://raw.githubusercontent.com/grandway2025/Actions-OpenWrt/main/Customize/Mediatek/kucat/style.css > package/new/kucat/luci-theme-kucat/htdocs/luci-static/kucat/css/style.css

# luci-app-kucat-config
git clone https://github.com/sirpdboy/luci-app-kucat-config package/new/luci-app-kucat-config

# 主题设置
sed -i 's|<a class="luci-link" href="https://github.com/openwrt/luci" target="_blank">Powered by <%= ver.luciname %> (<%= ver.luciversion %>)</a>|<a class="luci-link" href="https://github.com/grandway2025" target="_blank">OpenWrt定制版</a>|g' package/new/luci-theme-argon/luasrc/view/themes/argon/footer.htm
sed -i 's|<a class="luci-link" href="https://github.com/openwrt/luci" target="_blank">Powered by <%= ver.luciname %> (<%= ver.luciversion %>)</a>|<a class="luci-link" href="https://github.com/grandway2025" target="_blank">OpenWrt定制版</a>|g' package/new/luci-theme-argon/luasrc/view/themes/argon/footer_login.htm

##WiFi
# sed -i "s/MT7986_AX6000_2.4G/OpenWrt-2.4G/g" package/mtk/drivers/wifi-profile/files/mt7986/mt7986-ax6000.dbdc.b0.dat
# sed -i "s/MT7986_AX6000_5G/OpenWrt-5G/g" package/mtk/drivers/wifi-profile/files/mt7986/mt7986-ax6000.dbdc.b1.dat

##New WiFi
# sed -i "s/ImmortalWrt-2.4G/OpenWrt-2.4G/g" package/mtk/applications/mtwifi-cfg/files/mtwifi.sh
# sed -i "s/ImmortalWrt-5G/OpenWrt-5G/g" package/mtk/applications/mtwifi-cfg/files/mtwifi.sh

#添加额外软件包
# golang 1.25
rm -rf feeds/packages/lang/golang
git clone https://git.kejizero.online/zhao/packages_lang_golang -b 25.x feeds/packages/lang/golang

# SSRP & Passwall
rm -rf feeds/packages/net/{daed,xray-core,v2ray-core,v2ray-geodata,sing-box}
git clone -b openwrt-24.10 https://zhao:zj3753813@git.kejizero.online/zhao/openwrt_helloworld package/new/helloworld

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

# openlist
rm -rf feeds/luci/applications/luci-app-openlist
git clone https://github.com//sbwml/luci-app-openlist package/new/openlist

# socat
git clone https://github.com/zhiern/luci-app-socat package/new/luci-app-socat

# adguardhome
git clone https://git.kejizero.online/zhao/luci-app-adguardhome package/new/luci-app-adguardhome
mkdir -p files/usr/bin
AGH_CORE=$(curl -sL https://api.github.com/repos/AdguardTeam/AdGuardHome/releases/latest | grep /AdGuardHome_linux_arm64 | awk -F '"' '{print $4}')
wget -qO- $AGH_CORE | tar xOvz > files/usr/bin/AdGuardHome
chmod +x files/usr/bin/AdGuardHome

# openclash
mkdir -p files/etc/openclash/core
CLASH_META_URL="https://raw.githubusercontent.com/vernesong/OpenClash/core/master/meta/clash-linux-arm64.tar.gz"
GEOIP_URL="https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geoip.dat"
GEOSITE_URL="https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geosite.dat"
wget -qO- $CLASH_META_URL | tar xOvz > files/etc/openclash/core/clash_meta
wget -qO- $GEOIP_URL > files/etc/openclash/GeoIP.dat
wget -qO- $GEOSITE_URL > files/etc/openclash/GeoSite.dat
chmod +x files/etc/openclash/core/clash*

# Docker
rm -rf feeds/luci/applications/luci-app-dockerman
git clone https://git.kejizero.online/zhao/luci-app-dockerman -b openwrt-24.10 feeds/luci/applications/luci-app-dockerman
rm -rf feeds/packages/utils/{docker,dockerd,containerd,runc}
git clone https://git.kejizero.online/zhao/packages_utils_docker feeds/packages/utils/docker
git clone https://git.kejizero.online/zhao/packages_utils_dockerd feeds/packages/utils/dockerd
git clone https://git.kejizero.online/zhao/packages_utils_containerd feeds/packages/utils/containerd
git clone https://git.kejizero.online/zhao/packages_utils_runc feeds/packages/utils/runc

# default-settings 
rm -rf package/emortal/default-settings
git clone -b mediatek https://github.com/grandway2025/default-settings package/new/default-settings

# 更新feeds 
./scripts/feeds update -a && ./scripts/feeds install -a
