#!/bin/sh
. /usr/share/libubox/jshn.sh

# 配置 2.4GHz
uci set wireless.radio0.vendor_vht='1'
uci set wireless.radio0.noscan='1'
uci set wireless.radio0.country='US'
uci set wireless.radio0.disabled='0'
uci set wireless.radio0.cell_density='2'
uci set wireless.radio0.mu_beamformer='1'
uci set wireless.default_radio0.ssid='Cudy'
uci set wireless.default_radio0.encryption='sae-mixed'
uci set wireless.default_radio0.key='xyz2078ZT.'
uci set wireless.default_radio0.ieee80211k='1'
uci set wireless.default_radio0.time_advertisement='2'
uci set wireless.default_radio0.time_zone='CST-8'
uci set wireless.default_radio0.bss_transition='1'
uci set wireless.default_radio0.wnm_sleep_mode='1'
uci set wireless.default_radio0.wnm_sleep_mode_no_keys='1'

# 配置 5GHz
uci set wireless.radio1.country='US'
uci set wireless.radio1.disabled='0'
uci set wireless.radio1.cell_density='2'
uci set wireless.radio1.mu_beamformer='1'
uci set wireless.default_radio1.ssid='Cudy_5G'
uci set wireless.default_radio1.encryption='sae-mixed'
uci set wireless.default_radio1.key='xyz2078ZT.'
uci set wireless.default_radio1.ieee80211k='1'
uci set wireless.default_radio1.time_advertisement='2'
uci set wireless.default_radio1.time_zone='CST-8'
uci set wireless.default_radio1.bss_transition='1'
uci set wireless.default_radio1.wnm_sleep_mode='1'
uci set wireless.default_radio1.wnm_sleep_mode_no_keys='1'

# 提交配置并重启网络服务
uci commit wireless
exit 0