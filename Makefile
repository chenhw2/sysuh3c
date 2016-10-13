include $(TOPDIR)/rules.mk

PKG_NAME:=sysuh3c
PKG_VERSION:=0.2
PKG_RELEASE:=1

PKG_BUILD_DIR := $(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk

define Package/$(PKG_NAME)
	SECTION:=net
	CATEGORY:=Network
	DEPENDS:=+libc +libgcc
	TITLE:=SYSU-EAST CAMPUS H3C Client
	MAINTAINER:=chenhw2
endef

define Package/$(PKG_NAME)/description
	A CLI Client for H3C
endef

define Build/Prepare
	mkdir -p $(PKG_BUILD_DIR)
	$(CP) ./src/* $(PKG_BUILD_DIR)/
endef

#define Build/Configure
#endef

#define Build/Compile
#endef

#define Package/$(PKG_NAME)/conffiles
#endef

define Package/$(PKG_NAME)/install
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) ./files/sysuh3c.init $(1)/etc/init.d/sysuh3c
	$(INSTALL_DIR) $(1)/etc/config
	$(INSTALL_BIN) ./files/sysuh3c.config $(1)/etc/config/sysuh3c
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/sysuh3c $(1)/usr/bin
endef

#define Package/$(PKG_NAME)/preinst
#endef

#define Package/$(PKG_NAME)/postinst
#endef

define Package/$(PKG_NAME)/prerm
	#!/bin/sh
	if [ -f /var/run/sysuh3c.pid ]; then
		cat /var/run/sysuh3c.pid | while read SYSUH3C_LOCK; do kill -int $(SYSUH3C_LOCK); done
		rm -f /var/run/sysuh3c.pid
	fi
endef

#Package/$(PKG_NAME)/postrm
#endef

$(eval $(call BuildPackage,$(PKG_NAME)))
