module("luci.controller.pingcontrol", package.seeall)

function index()
	entry( {"admin", "services", "pingcontrol"}, cbi("pingcontrol"), _("PingControl") )
end
