#!/usr/bin/env ucode
import { readfile } from "fs";
import * as uci from 'uci';

const bands_order = [ "6G", "5G", "2G" ];
const htmode_order = [ "EHT", "HE", "VHT", "HT" ];

let board = json(readfile("/etc/board.json"));
if (!board.wlan)
	exit(0);

let idx = 0;
let commit;

let config = uci.cursor().get_all("wireless") ?? {};

function radio_exists(path, macaddr, phy, radio) {
	for (let name, s in config) {
		if (s[".type"] != "wifi-device")
			continue;
		if (radio != null && int(s.radio) != radio)
			continue;
		if (s.macaddr & lc(s.macaddr) == lc(macaddr))
			return true;
		if (s.phy == phy)
			return true;
		if (!s.path || !path)
			continue;
		if (substr(s.path, -length(path)) == path)
			return true;
	}
}

for (let phy_name, phy in board.wlan) {
	let info = phy.info;
	if (!info || !length(info.bands))
		continue;

	let radios = length(info.radios) > 0 ? info.radios : [{ bands: info.bands }];
	for (let radio in radios) {
		while (config[`radio${idx}`])
			idx++;
		let name = "radio" + idx;

		let s = "wireless." + name;
		let si = "wireless.default_" + name;

		let band_name = filter(bands_order, (b) => radio.bands[b])[0];
		if (!band_name)
			continue;

		let band = info.bands[band_name];
		let rband = radio.bands[band_name];
		let channel = rband.default_channel ?? "auto";

		let width = band.max_width;
		if (band_name == "2G")
			width = 40;
		else if (band_name == "5G")
			width = 160;

		let htmode = filter(htmode_order, (m) => band[lc(m)])[0];
		if (htmode)
			htmode = "HE" + width;
		else
			htmode = "NOHT";

		if (!phy.path)
			continue;

		let macaddr = trim(readfile(`/sys/class/ieee80211/${phy_name}/macaddress`));
		if (radio_exists(phy.path, macaddr, phy_name, radio.index))
			continue;

		let id = `phy='${phy_name}'`;
		if (match(phy_name, /^phy[0-9]/))
			id = `path='${phy.path}'`;

		band_name = lc(band_name);

		let country_code = 'AU';
		let ssid = band_name === '2g' ? 'Filogic_2.4G' : 'Filogic_5G';
		let password = 'qtxyz050618ZTzt.';

		if (length(info.radios) > 0)
			id += `\nset ${s}.radio='${radio.index}'`;

		print(`set ${s}=wifi-device
set ${s}.type='mac80211'
set ${s}.${id}
set ${s}.band='${band_name}'
set ${s}.channel='${channel}'
set ${s}.htmode='${htmode}'
set ${s}.country='${country_code}'
set ${s}.mu_beamformer='1'
set ${s}.cell_density='1'
set ${s}.disabled='0'

set ${si}=wifi-iface
set ${si}.device='${name}'
set ${si}.network='lan'
set ${si}.mode='ap'
set ${si}.ssid='${ssid}'
set ${si}.encryption='sae'
set ${si}.key='${password}'
set ${si}.ieee80211k='1'
set ${si}.time_advertisement='2'
set ${si}.time_zone='CST-8'
set ${si}.wnm_sleep_mode='1'
set ${si}.wnm_sleep_mode_no_keys='1'
set ${si}.bss_transition='1'
set ${si}.ocv='0'
set ${si}.disabled='0'

`);
		config[name] = {};
		commit = true;
	}
}

if (commit)
	print("commit wireless\n");
