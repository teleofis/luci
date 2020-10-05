-- Copyright 2016 David Thornley <david.thornley@touchstargroup.com>
-- Licensed to the public under the Apache License 2.0.

local map, section, net = ...

local apn, pincode, username, password
local auth, ipv6, device

device = section:taboption("general", Value, "device", translate("Interface name"))
device.default = "rmnet_data0"

mode = section:taboption("general", ListValue, "mode", translate("Preferred Mode"))
mode:value("all", translate("Auto (LTE>UMTS>GPS)"))
mode:value("lte", translate("LTE only"))
mode:value("umts", translate("UMTS only"))
mode:value("gsm", translate("GPRS only"))
mode.default = "all"

local simman = map.uci:get("simman", "core", "enabled") or "0"
if simman == "0" then
	apn = section:taboption("general", Value, "apn", translate("APN"))
	pincode = section:taboption("general", Value, "pincode", translate("PIN"))
	username = section:taboption("general", Value, "username", translate("PAP/CHAP username"))
	password = section:taboption("general", Value, "password", translate("PAP/CHAP password"))
	password.password = true
else
	apn = section:taboption("general", DummyValue, "apn", translate("APN"), translate("You can configure this value in the SIM manager, or after disabling it"))
	pincode = section:taboption("general", DummyValue, "pincode", translate("PIN"), translate("You can configure this value in the SIM manager, or after disabling it"))
	username = section:taboption("general", DummyValue, "username", translate("PAP/CHAP username"), translate("You can configure this value in the SIM manager, or after disabling it"))
	password = section:taboption("general", DummyValue, "password", translate("PAP/CHAP password"), translate("You can configure this value in the SIM manager, or after disabling it"))
end	

auth = section:taboption("general", Value, "auth", translate("Authentication Type"))
auth:value("", translate("-- Please choose --"))
auth:value("both", "PAP/CHAP (both)")
auth:value("pap", "PAP")
auth:value("chap", "CHAP")
auth:value("none", "NONE")

if luci.model.network:has_ipv6() then
    ipv6 = section:taboption("advanced", Flag, "ipv6", translate("Enable IPv6 negotiation"))
    ipv6.default = ipv6.disabled
end

defaultroute = section:taboption("advanced", Flag, "defaultroute",
	translate("Use default gateway"),
	translate("If unchecked, no default route is configured"))
defaultroute.default = defaultroute.enabled

metric = section:taboption("advanced", Value, "metric",
	translate("Use gateway metric"))
metric.placeholder = "0"
metric.datatype    = "uinteger"
metric:depends("defaultroute", defaultroute.enabled)

peerdns = section:taboption("advanced", Flag, "peerdns",
	translate("Use DNS servers advertised by peer"),
	translate("If unchecked, the advertised DNS server addresses are ignored"))
peerdns.default = peerdns.enabled

dns = section:taboption("advanced", DynamicList, "dns",
	translate("Use custom DNS servers"))
dns:depends("peerdns", "")
dns.datatype = "ipaddr"
dns.cast     = "string"
