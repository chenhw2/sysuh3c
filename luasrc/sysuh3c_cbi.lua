require("luci.sys")

if luci.sys.call("pidof sysuh3c >/dev/null") == 0 then
	m = Map("sysuh3c", translate("SYSU-H3C"), translate("Configure SYSU H3C.  - <div class=\"errorbox\">sysuh3c is running</div>"))
else
	m = Map("sysuh3c", translate("SYSU-H3C"), translate("Configure SYSU H3C.  - <div class=\"error\">sysuh3c is not running</div>"))
end
m.reset = false

s = m:section(TypedSection, "sysuh3c", "")
s.addremove = false
s.anonymous = true

enable = s:option(Flag, "enable", translate("Enable"))
un = s:option(Value, "username", translate("Username"))
pw = s:option(Value, "password", translate("Password"))
pw.password = true

method = s:option(ListValue, "method", "Method")
method:value("md5", "MD5")
method:value("xor", "XOR")
method.default = md5

local apply = luci.http.formvalue("cbi.apply")
if apply then
	io.popen("/etc/init.d/sysuh3c restart")
end

return m
