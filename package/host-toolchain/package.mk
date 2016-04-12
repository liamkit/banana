#
# build just the compiler. 
#
GIT_MODULE		= buildroot
VERSION			= 2016.02

KCONFIG			= toolchain_sunxi

#
# fixup .config
#
post-configure:: $(PKG_TIMESTAMP.post-cfg)

$(PKG_TIMESTAMP.post-cfg):
	@sed -i -e "/^BR2_HOST_DIR/s@=.*@=\"$(TLD_TOOLCHAIN_DIR)\"@"	\
		-e "/^BR2_DL_DIR/s@=.*@=\"$(TLD_CACHE_DIR)\"@"		\
	 $(PKG_SOURCE_DIR)/.config


clobber::
	@$(call CMD_RM_DIR,$(TLD_TOOLCHAIN_DIR))
