#!/bin/bash

# =====================
# 配置参数
# =====================

##配置IP
sed -i "s/192.168.6.1/$LAN/g" package/base-files/files/bin/config_generate

# default name
sed -i 's/ImmortalWrt/OpenWrt/' package/base-files/files/bin/config_generate

# TTYD 免登录
sed -i 's|/bin/login|/bin/login -f root|g' feeds/packages/utils/ttyd/files/ttyd.config

# 为默认 root 密码进行设置
if [ -n "$ROOT_PASSWORD" ]; then
    # sha256 encryption
    default_password=$(openssl passwd -5 $ROOT_PASSWORD)
    sed -i "s|^root:[^:]*:|root:${default_password}:|" package/base-files/files/etc/shadow
fi

# 删除软件依赖
rm -rf feeds/packages/net/{v2ray-geodata,open-app-filter,shadowsocksr-libev,shadowsocks-rust,shadowsocks-libev}
rm -rf feeds/packages/net/{tcping,trojan,trojan-plus,tuic-client,v2ray-core,v2ray-plugin,xray-core,xray-plugin,sing-box}
rm -rf feeds/packages/net/{chinadns-ng,hysteria,mosdns,lucky,ddns-go,v2dat,golang}

# 删除软件包
rm -rf feeds/luci/applications/{luci-app-daed,luci-app-dae,luci-app-homeproxy,luci-app-openclash}
rm -rf feeds/luci/applications/{luci-app-passwall,luci-app-passwall2,luci-app-ssr-plus,luci-app-vssr}
rm -rf feeds/luci/applications/{luci-app-appfilter,luci-app-ddns-go,luci-app-lucky,luci-app-mosdns,luci-app-alist,luci-app-openlist,luci-app-airwhu}

# 加入作者信息
sed -i "s/DISTRIB_DESCRIPTION='*.*'/DISTRIB_DESCRIPTION='OpenWrt-$(date +%Y%m%d)'/g"  package/base-files/files/etc/openwrt_release
sed -i "s/DISTRIB_REVISION='*.*'/DISTRIB_REVISION=' By grandway2025'/g" package/base-files/files/etc/openwrt_release
sed -i "s|^OPENWRT_RELEASE=\".*\"|OPENWRT_RELEASE=\"OpenWrt定制版 \"|" package/base-files/files/usr/lib/os-release


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
rm -rf feeds/packages/net/{xray-core,v2ray-core,v2ray-geodata,sing-box}
git clone https://github.com/sbwml/openwrt_helloworld package/new/helloworld -b v5 --depth=1

# PowerOff 关机插件
git clone https://github.com/sirpdboy/luci-app-poweroffdevice package/new/poweroff
mv -n package/new/poweroff/luci-app-poweroffdevice package/new/luci-app-poweroffdevice && rm -rf package/new/poweroff

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
git clone https://github.com/sbwml/luci-app-openlist2 package/new/openlist --depth=1

# socat
git clone https://github.com/zhiern/luci-app-socat package/new/luci-app-socat

# argon && argon-config
rm -rf feeds/luci/themes/luci-theme-argon
git clone https://github.com/grandway2025/argon package/new/luci-theme-argon --depth=1

# luci-app-advancedplus
git clone https://$github/sirpdboy/luci-app-advancedplus.git package/new/luci-app-advancedplus --depth=1

# luci-theme-kucat
git clone https://github.com/sirpdboy/luci-theme-kucat.git package/new/kucat
mv -n package/new/kucat/luci-theme-kucat package/new/luci-theme-kucat && rm -rf package/new/kucat

# openclash
mkdir -p files/etc/openclash/core
mkdir -p files/etc/config
CLASH_META_URL="https://raw.githubusercontent.com/vernesong/OpenClash/core/master/meta/clash-linux-arm64.tar.gz"
GEOIP_URL="https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geoip.dat"
GEOSITE_URL="https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geosite.dat"
CLASH_URL="https://github.com/grandway2025/Actions-OpenWrt/raw/refs/heads/main/files/openclash"
NIKKI_URL="https://github.com/grandway2025/Actions-OpenWrt/raw/refs/heads/main/files/nikki"
ARGON_URL="https://github.com/grandway2025/Actions-OpenWrt/raw/refs/heads/main/files/argon"
ADP_URL="https://github.com/grandway2025/Actions-OpenWrt/raw/refs/heads/main/files/advancedplus"
wget -qO- $CLASH_META_URL | tar xOvz > files/etc/openclash/core/clash_meta
wget -qO- $GEOIP_URL > files/etc/openclash/GeoIP.dat
wget -qO- $GEOSITE_URL > files/etc/openclash/GeoSite.dat
wget -qO- $CLASH_URL > files/etc/config/openclash
wget -qO- $NIKKI_URL > files/etc/config/nikki
wget -qO- $ARGON_URL > files/etc/config/argon
wget -qO- $ADP_URL > files/etc/config/advancedplus
chmod +x files/etc/openclash/core/clash*
chmod +x files/etc/config/openclash
chmod +x files/etc/config/nikki
chmod +x files/etc/config/argon
chmod +x files/etc/config/advancedplus

# adguardhome
git clone https://git.kejizero.online/zhao/luci-app-adguardhome package/new/luci-app-adguardhome
mkdir -p files/usr/bin
AGH_CORE=$(curl -sL https://api.github.com/repos/AdguardTeam/AdGuardHome/releases/latest | grep /AdGuardHome_linux_arm64 | awk -F '"' '{print $4}')
AGH_YAML="https://github.com/grandway2025/Actions-OpenWrt/raw/refs/heads/main/files/AdGuardHome.yaml"
wget -qO- $AGH_CORE | tar xOvz > files/usr/bin/AdGuardHome
chmod +x files/usr/bin/AdGuardHome
wget -qO- $AGH_CORE | tar xOvz > files/usr/bin/AdGuardHome
wget -qO- $AGH_YAML > files/etc/AdGuardHome.yaml
chmod +x files/usr/bin/AdGuardHome
chmod +x files/etc/AdGuardHome.yaml

# Docker
rm -rf feeds/luci/applications/luci-app-dockerman
git clone https://github.com/sirpdboy/luci-app-dockerman.git package/new/dockerman
mv -n package/new/dockerman/luci-app-dockerman feeds/luci/applications && rm -rf package/new/dockerman
rm -rf feeds/packages/utils/{docker,dockerd,containerd,runc}
git clone https://github.com/sbwml/packages_utils_docker feeds/packages/utils/docker
git clone https://github.com/sbwml/packages_utils_dockerd feeds/packages/utils/dockerd
git clone https://github.com/sbwml/packages_utils_containerd feeds/packages/utils/containerd
git clone https://github.com/sbwml/packages_utils_runc feeds/packages/utils/runc

# default-settings 
# rm -rf package/emortal/default-settings
# git clone -b mediatek https://github.com/grandway2025/default-settings package/new/default-settings --depth=1
