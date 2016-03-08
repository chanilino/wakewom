#
# This is free software, licensed under the GNU General Public License v2.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=wakewom
PKG_VERSION:=1.0.0
PKG_RELEASE:=1

PKG_LICENSE:=GPL-2.0

include $(INCLUDE_DIR)/package.mk


define Package/$(PKG_NAME)/Default
    TITLE:=Wake Wifi on mac adresss detection
	SECTION:=utils
	CATEGORY:=Utilities
    PKGARCH:=all
	DEPENDS:=+iw +!PACKAGE_tcpdump:tcpdump-mini
endef

##### **********************************
define Package/$(PKG_NAME)
    $(call Package/$(PKG_NAME)/Default)
endef

define Package/$(PKG_NAME)/description
    Wake Wifi on mac address detection. It needs support for mode monitor on your wireless card driver.
endef

# shown in menuconfig <Help>
define Package/$(PKG_NAME)/config
	help
		This would be the help
		  - you need mode monitor
		  - Depends on iw and tcpdump or mini-tcpdump
		  - Multiple mac can wake up
		  - Power off the wifi when no clients.
		  - Timeout when no clients configurable
		.
		Version: $(PKG_VERSION)-$(PKG_RELEASE)
		.
endef

#Do nothing at compile
define Build/Configure
endef
define Build/Compile
		$(CP) ./files $(PKG_BUILD_DIR)
endef


##### **********************************
define Package/$(PKG_NAME)/install
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/files/wakewom.init $(1)/etc/init.d/wakewom
	$(INSTALL_DIR) $(1)/etc/config
	$(INSTALL_CONF) $(PKG_BUILD_DIR)/files/wakewom.config $(1)/etc/config/wakewom
	$(INSTALL_DIR) $(1)/usr/lib/wakewon
	$(INSTALL_CONF) $(PKG_BUILD_DIR)/files/wakewom.sh $(1)/usr/lib/wakewon/wakewom.sh
endef

define Package/$(PKG_NAME)/prerm
	#!/bin/sh
	# if run within buildroot exit
	[ -n "$${IPKG_INSTROOT}" ] && exit 0

	# stop running scripts
	/etc/init.d/wakewom disable
	/etc/init.d/wakewom stop

	exit 0
endef


##### **********************************
$(eval $(call BuildPackage,$(PKG_NAME)))
