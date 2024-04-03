#!/bin/bash
#
# Copyright (c) 2020-2024 JE <https://gihub.com/JE668>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/JE668/Phicomm-K3-LEDE-Firmware-Lean
# File name: beta/diy-part1.sh
# Description: OpenWrt DIY script part 1 (Before Update feeds)
#

# Uncomment a feed source
# sed -i 's/^#\(.*helloworld\)/\1/' feeds.conf.default

# Add a feed source
# echo 'src-git helloworld https://github.com/fw876/helloworld' >>feeds.conf.default
# echo 'src-git passwall https://github.com/xiaorouji/openwrt-passwall' >>feeds.conf.default

echo '添加Haiibo软件源'
sed -i '1i src-git haiibo https://github.com/haiibo/openwrt-packages' feeds.conf.default
echo '=========Add Haiibo source OK!========='

echo '添加AdguardHome'
rm -rf feeds/haiibo/adguardhome
rm -rf feeds/haiibo/luci-app-adguardhome
rm -rf package/feeds/haiibo/luci-app-adguardhome
rm -rf package/feeds/haiibo/adguardhome
rm -rf package/lean/luci-app-adguardhome
git clone https://github.com/kongfl888/luci-app-adguardhome package/lean/luci-app-adguardhome 
echo '=========Add AdguardHome OK!========='

echo '添加MosDNS'
rm -rf feeds/packages/net/v2ray-geodata
rm -rf feeds/haiibo/luci-app-mosdns
rm -rf feeds/haiibo/mosdns
rm -rf package/feeds/haiibo/luci-app-mosdns
rm -rf package/feeds/haiibo/mosdns
rm -rf package/lean/luci-app-adguardhome
git clone https://github.com/sbwml/luci-app-mosdns -b v5 package/mosdns
git clone https://github.com/sbwml/v2ray-geodata package/v2ray-geodata
echo '=========Add MosDNS OK!========='

echo '添加lwz322的K3屏幕插件'
rm -rf package/lean/luci-app-k3screenctrl
git clone https://github.com/JE668/luci-app-k3screenctrl.git package/lean/luci-app-k3screenctrl
echo '=========Add k3screen plug OK!========='

echo '替换lwz322的K3屏幕驱动插件'
rm -rf package/lean/k3screenctrl
git clone https://github.com/JE668/k3screenctrl_build.git package/lean/k3screenctrl/
echo '=========Replace k3screen drive plug OK!========='

echo '移除bcm53xx中的其他机型'
sed -i '421,453d' target/linux/bcm53xx/image/Makefile
sed -i '140,412d' target/linux/bcm53xx/image/Makefile
sed -i 's/$(USB3_PACKAGES) k3screenctrl/luci-app-k3screenctrl/g' target/linux/bcm53xx/image/Makefile
# sed -n '140,146p' target/linux/bcm53xx/image/Makefile
echo '=========Remove other devices of bcm53xx OK!========='

#1.'asus_dhd24' 2.'ac88u_20' 3.'69027'
firmware='69027'
echo '替换无线驱动'
wget -nv https://github.com/JE668/Phicomm-k3-Wireless-Firmware/raw/master/brcmfmac4366c-pcie.bin.${firmware} -O package/lean/k3-brcmfmac4366c-firmware/files/lib/firmware/brcm/brcmfmac4366c-pcie.bin
echo '=========Replace k3 wireless firmware OK!========='
