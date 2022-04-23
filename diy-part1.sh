#!/bin/bash
#
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part1.sh
# Description: OpenWrt DIY script part 1 (Before Update feeds)
#

# Uncomment a feed source
#sed -i 's/^#\(.*helloworld\)/\1/' feeds.conf.default

# Add a feed source
#echo 'src-git helloworld https://github.com/fw876/helloworld' >>feeds.conf.default
#echo 'src-git passwall https://github.com/xiaorouji/openwrt-passwall' >>feeds.conf.default
# Argon 主题
git clone https://github.com/jerrykuku/luci-theme-argon.git package/new/luci-theme-argon
wget -P package/new/luci-theme-argon/htdocs/luci-static/argon/background/ https://github.com/QiuSimons/OpenWrt-Add/raw/master/5808303.jpg
rm -rf ./package/new/luci-theme-argon/htdocs/luci-static/argon/background/README.md
# Edge 主题
git clone -b master --depth 1 https://github.com/kiddin9/luci-theme-edge.git package/new/luci-theme-edge
# 花生壳内网穿透
svn export https://github.com/teasiu/dragino2/trunk/devices/common/diy/package/teasiu/luci-app-phtunnel package/new/luci-app-phtunnel
svn export https://github.com/teasiu/dragino2/trunk/devices/common/diy/package/teasiu/phtunnel package/new/phtunnel
svn export https://github.com/QiuSimons/dragino2-teasiu/trunk/package/teasiu/luci-app-oray package/new/luci-app-oray
# ShadowsocksR Plus+ 依赖
rm -rf ./feeds/packages/net/kcptun
rm -rf ./feeds/packages/net/shadowsocks-libev
rm -rf ./feeds/packages/net/xray-core
svn export https://github.com/coolsnowwolf/packages/trunk/net/shadowsocks-libev package/lean/shadowsocks-libev
svn export https://github.com/xiaorouji/openwrt-passwall/trunk/shadowsocksr-libev package/lean/shadowsocksr-libev
svn export https://github.com/xiaorouji/openwrt-passwall/trunk/pdnsd-alt package/lean/pdnsd
svn export https://github.com/coolsnowwolf/lede/trunk/package/lean/srelay package/lean/srelay
svn export https://github.com/xiaorouji/openwrt-passwall/trunk/microsocks package/lean/microsocks
svn export https://github.com/xiaorouji/openwrt-passwall/trunk/dns2socks package/lean/dns2socks
svn export https://github.com/coolsnowwolf/packages/trunk/net/redsocks2 package/lean/redsocks2
svn export https://github.com/xiaorouji/openwrt-passwall/trunk/ipt2socks package/lean/ipt2socks
svn export https://github.com/xiaorouji/openwrt-passwall/trunk/trojan package/lean/trojan
svn export https://github.com/xiaorouji/openwrt-passwall/trunk/tcping package/lean/tcping
svn export https://github.com/xiaorouji/openwrt-passwall/trunk/trojan-go package/lean/trojan-go
svn export https://github.com/fw876/helloworld/trunk/simple-obfs package/lean/simple-obfs
svn export https://github.com/fw876/helloworld/trunk/naiveproxy package/lean/naiveproxy
svn export https://github.com/fw876/helloworld/trunk/v2ray-core package/lean/v2ray-core
svn export https://github.com/fw876/helloworld/trunk/xray-core package/lean/xray-core
svn export https://github.com/fw876/helloworld/trunk/v2ray-plugin package/lean/v2ray-plugin
svn export https://github.com/fw876/helloworld/trunk/xray-plugin package/lean/xray-plugin
svn export https://github.com/xiaorouji/openwrt-passwall/trunk/shadowsocks-rust feeds/packages/net/shadowsocks-rust
#svn export https://github.com/immortalwrt/packages/trunk/net/shadowsocks-rust feeds/packages/net/shadowsocks-rust
sed -i '/Build\/Compile/a\\t$(STAGING_DIR_HOST)/bin/upx --lzma --best $$(PKG_BUILD_DIR)/$(component)' feeds/packages/net/shadowsocks-rust/Makefile
ln -sf ../../../feeds/packages/net/shadowsocks-rust ./package/feeds/packages/shadowsocks-rust
svn export https://github.com/immortalwrt/packages/trunk/net/kcptun feeds/packages/net/kcptun
ln -sf ../../../feeds/packages/net/kcptun ./package/feeds/packages/kcptun
# ShadowsocksR Plus+
svn export https://github.com/fw876/helloworld/trunk/luci-app-ssr-plus package/lean/luci-app-ssr-plus
rm -rf ./package/lean/luci-app-ssr-plus/po/zh_Hans
pushd package/lean
#wget -qO - https://github.com/fw876/helloworld/pull/656.patch | patch -p1
wget -qO - https://github.com/QiuSimons/helloworld-fw876/commit/5bbf6e7.patch | patch -p1
wget -qO - https://github.com/QiuSimons/helloworld-fw876/commit/323fbf0.patch | patch -p1
popd
pushd package/lean/luci-app-ssr-plus
sed -i 's,default n,default y,g' Makefile
sed -i '/trojan-go/d' Makefile
sed -i '/v2ray-core/d' Makefile
sed -i '/v2ray-plugin/d' Makefile
sed -i '/xray-plugin/d' Makefile
sed -i '/shadowsocks-libev-ss-redir/d' Makefile
sed -i '/shadowsocks-libev-ss-server/d' Makefile
sed -i '/shadowsocks-libev-ss-local/d' Makefile
sed -i '/result.encrypt_method/a\result.fast_open = "1"' root/usr/share/shadowsocksr/subscribe.lua
sed -i 's,ispip.clang.cn/all_cn,gh.404delivr.workers.dev/https://github.com/QiuSimons/Chnroute/raw/master/dist/chnroute/chnroute,' root/etc/init.d/shadowsocksr
sed -i 's,YW5vbnltb3Vz/domain-list-community/release/gfwlist.txt,Loyalsoldier/v2ray-rules-dat/release/gfw.txt,' root/etc/init.d/shadowsocksr
sed -i '/Clang.CN.CIDR/a\o:value("https://gh.404delivr.workers.dev/https://github.com/QiuSimons/Chnroute/raw/master/dist/chnroute/chnroute.txt", translate("QiuSimons/Chnroute"))' luasrc/model/cbi/shadowsocksr/advanced.lua
popd
svn export https://github.com/immortalwrt/packages/trunk/net/subconverter feeds/packages/net/subconverter
wget https://github.com/immortalwrt/packages/raw/b7b4499/net/subconverter/Makefile -O feeds/packages/net/subconverter/Makefile
mkdir -p ./feeds/packages/net/subconverter/patches
wget https://github.com/immortalwrt/packages/raw/b7b4499/net/subconverter/patches/100-stdcxxfs.patch -O feeds/packages/net/subconverter/patches/100-stdcxxfs.patch
sed -i '\/bin\/subconverter/a\\t$(STAGING_DIR_HOST)/bin/upx --lzma --best $(1)/usr/bin/subconverter' feeds/packages/net/subconverter/Makefile
ln -sf ../../../feeds/packages/net/subconverter ./package/feeds/packages/subconverter
svn export https://github.com/immortalwrt/packages/trunk/libs/jpcre2 feeds/packages/libs/jpcre2
ln -sf ../../../feeds/packages/libs/jpcre2 ./package/feeds/packages/jpcre2
svn export https://github.com/immortalwrt/packages/trunk/libs/rapidjson feeds/packages/libs/rapidjson
ln -sf ../../../feeds/packages/libs/rapidjson ./package/feeds/packages/rapidjson
svn export https://github.com/immortalwrt/packages/trunk/libs/libcron feeds/packages/libs/libcron
wget https://github.com/immortalwrt/packages/raw/b7b4499/libs/libcron/Makefile -O feeds/packages/libs/libcron/Makefile
ln -sf ../../../feeds/packages/libs/libcron ./package/feeds/packages/libcron
svn export https://github.com/immortalwrt/packages/trunk/libs/quickjspp feeds/packages/libs/quickjspp
wget https://github.com/immortalwrt/packages/raw/b7b4499/libs/quickjspp/Makefile -O feeds/packages/libs/quickjspp/Makefile
ln -sf ../../../feeds/packages/libs/quickjspp ./package/feeds/packages/quickjspp
svn export https://github.com/immortalwrt/packages/trunk/libs/toml11 feeds/packages/libs/toml11
ln -sf ../../../feeds/packages/libs/toml11 ./package/feeds/packages/toml11
# UU加速器
svn export https://github.com/coolsnowwolf/luci/trunk/applications/luci-app-uugamebooster package/lean/luci-app-uugamebooster
svn export https://github.com/coolsnowwolf/packages/trunk/net/uugamebooster package/lean/uugamebooster