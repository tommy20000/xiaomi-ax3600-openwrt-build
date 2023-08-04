###
# @Author: zhkong
# @Date: 2023-07-25 17:07:02
 # @LastEditors: zhkong
 # @LastEditTime: 2023-08-04 13:22:36
 # @FilePath: /xiaomi-ax3600-openwrt-build/scripts/prepare.sh
# @Description: Do not edit
###

git clone https://github.com/zhkong/openwrt-ipq807x.git -b qualcommax-6.1-nss --single-branch openwrt
cd openwrt

# 更新 Feeds
./scripts/feeds update -a
./scripts/feeds install -a

# 添加第三方软件包
git clone https://github.com/vernesong/OpenClash.git --single-branch --depth 1 package/new/luci-openclash
git clone https://github.com/jerrykuku/luci-theme-argon.git --single-branch --depth 1  package/new/luci-theme-argon
git clone https://github.com/flytosky-f/openwrt-vlmcsd.git --single-branch --depth 1 package/new/vlmcsd
git clone https://github.com/ssuperh/luci-app-vlmcsd-new.git --single-branch --depth 1 package/new/luci-app-vlmcsd-new
# AutoCore
svn export https://github.com/immortalwrt/immortalwrt/branches/openwrt-23.05/package/emortal/autocore package/new/autocore
sed -i 's/"getTempInfo" /"getTempInfo", "getCPUBench", "getCPUUsage" /g' package/new/autocore/files/luci-mod-status-autocore.json

rm -rf feeds/luci/modules/luci-base
rm -rf feeds/luci/modules/luci-mod-status
rm -rf feeds/packages/utils/coremark
rm -rf package/emortal/default-settings

svn export https://github.com/immortalwrt/luci/branches/openwrt-23.05/modules/luci-base  feeds/luci/modules/luci-base
svn export https://github.com/immortalwrt/luci/branches/openwrt-23.05/modules/luci-mod-status feeds/luci/modules/luci-mod-status
svn export https://github.com/immortalwrt/packages/branches/openwrt-23.05/utils/coremark feeds/packages/utils/coremark
svn export https://github.com/immortalwrt/immortalwrt/branches/openwrt-23.05/package/emortal/default-settings package/emortal/default-settings
# svn export https://github.com/immortalwrt/immortalwrt/branches/openwrt-23.05/package/utils/mhz package/utils/mhz

# 修复Architecture显示错误问题
# sed -i 's/cpuinfo.cpuinfo || boardinfo.system/boardinfo.system/g' feeds/luci/modules/luci-mod-status/htdocs/luci-static/resources/view/status/include/10_system.js



# config file
# cp ../config/xiaomi_ax3600-stock.config .config
cp ../config/xiaomi_ax3600-stock.config .config
make defconfig

# # # 编译固件
# make download -j$(nproc)
# make -j$(nproc) || make -j1 V=s
