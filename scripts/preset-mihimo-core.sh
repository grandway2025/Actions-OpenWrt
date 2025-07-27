#!/bin/bash

mkdir -p files/etc/openclash/core

CLASH_META_URL="https://github.com/vernesong/mihomo/releases/download/Prerelease-Alpha/mihomo-linux-amd64-alpha-smart-5bc3f7d.gz"
GEOIP_URL="https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geoip.dat"
GEOSITE_URL="https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geosite.dat"
MODEL_URL="https://github.com/vernesong/mihomo/releases/download/LightGBM-Model/model-large.bin"

wget -qO- $CLASH_META_URL | gzip -d > files/etc/openclash/core/mihomo-linux-amd64
wget -qO- $GEOIP_URL > files/etc/openclash/GeoIP.dat
wget -qO- $GEOSITE_URL > files/etc/openclash/GeoSite.dat
wget -qO- $MODEL_URL > files/etc/openclash/model.bin

chmod +x files/etc/openclash/core/mihomo*
