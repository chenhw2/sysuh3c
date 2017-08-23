include $(TOPDIR)/rules.mk

PKG_NAME:=sysuh3c
PKG_VERSION:=0.3
PKG_RELEASE:=1

PKG_BUILD_DIR := $(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk

define Package/$(PKG_NAME)
        SECTION:=utils
        CATEGORY:=Utilities
        DEPENDS:=+libc +libgcc
        TITLE:=sysuh3c
        MAINTAINER:=zonyitoo
endef

define Package/$(PKG_NAME)/description
      	A CLI Client for H3C
endef

define Build/Prepare
		mkdir -p $(PKG_BUILD_DIR)
		$(CP) ./src/* $(PKG_BUILD_DIR)/
endef



define Package/$(PKG_NAME)/install
		$(INSTALL_DIR) $(1)/usr/bin
		$(INSTALL_BIN) $(PKG_BUILD_DIR)/sysuh3c $(1)/usr/bin
endef


define Package/$(PKG_NAME)/prerm
		#!/bin/sh
		if [ -f /var/run/sysuh3c.pid ]; then
			cat /var/run/sysuh3c.pid | while read SYSUH3C_LOCK; do kill -int $(SYSUH3C_LOCK); done
			rm -f /var/run/sysuh3c.pid
		fi
endef

$(eval $(call BuildPackage,$(PKG_NAME)))

################################################################################

PKG_LUCI_NAME:=luci-app-sysuh3c

define Package/$(PKG_LUCI_NAME)
	SECTION:=luci
	CATEGORY:=LuCI
	SUBMENU:=3. Applications
	TITLE:=LuCI Support for sysuh3c
	DEPENDS:=+sysuh3c
	MAINTAINER:=chenhw2
	PKGARCH:=all
endef

define Package/$(PKG_LUCI_NAME)/description
	LuCI Support for SYSU H3C.
endef

define Package/$(PKG_LUCI_NAME)/conffiles
/etc/config/sysuh3c
endef

define Package/$(PKG_LUCI_NAME)/install
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) ./files/sysuh3c.init $(1)/etc/init.d/sysuh3c
	$(INSTALL_DIR) $(1)/etc/config
	$(INSTALL_BIN) ./files/sysuh3c.config $(1)/etc/config/sysuh3c
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/controller
	$(INSTALL_DATA) ./luasrc/sysuh3c_controller.lua $(1)/usr/lib/lua/luci/controller/sysuh3c.lua
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/model/cbi
	$(INSTALL_DATA) ./luasrc/sysuh3c_cbi.lua $(1)/usr/lib/lua/luci/model/cbi/sysuh3c.lua
endef

define Package/$(PKG_LUCI_NAME)/postinst
#!/bin/sh
if [ -z "$${IPKG_INSTROOT}" ]; then
	uci -q batch <<-EOF >/dev/null
	delete ucitrack.@$(PKG_LUCI_NAME)[-1]
	add ucitrack $(PKG_LUCI_NAME)
	set ucitrack.@$(PKG_LUCI_NAME)[-1].init=$(PKG_LUCI_NAME)
	commit ucitrack
EOF
	rm -rf /tmp/luci-indexcache /tmp/luci-modulecache
fi
exit 0
endef


$(eval $(call BuildPackage,$(PKG_LUCI_NAME)))
