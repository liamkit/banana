#
# base the base system
#
GIT_MODULE	= buildroot
VERSION		= 2016.02

KCONFIG		= basefs

#
# fixup .config
#
CONFIG_FILE	= $(PKG_SOURCE_DIR)/.config

post-configure:: $(PKG_TIMESTAMP.post-cfg)

$(PKG_TIMESTAMP.post-cfg):
	@mkdir -p $(@D)
	@sed \
		-e "/^BR2_DL_DIR/s@=.*@=\"$(TLD_CACHE_DIR)\"@"		\
		-e "/^BR2_HOST_DIR/s@=.*@=\"$(TLD_TOOLS_DIR)\"@"	\
		-e "/^BR2_TOOLCHAIN_EXTERNAL_PATH/s@=.*@=\"$(TLD_TOOLCHAIN_DIR)/usr\"@"	\
		$(CONFIG_FILE) > $(CONFIG_FILE).tmp
	@mv $(CONFIG_FILE).tmp $(CONFIG_FILE)
	@touch $@


post-install:: $(PKG_TIMESTAMP.post-install)

$(PKG_TIMESTAMP.post-install):
	@mkdir -p $(@D) $(TLD_SYSROOT_DIR)
	tar xf $(PKG_BUILD_DIR)/output/images/rootfs.tar --exclude="*/dev/*" -C $(TLD_SYSROOT_DIR)
	@touch $@

