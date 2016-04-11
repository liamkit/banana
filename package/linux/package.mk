#
# build linux - we build the zImage and the dtb. the full kernel is catting these two files and install to /boot/vmlinuz
#
GIT_MODULE	= linux
VERSION		= v4.4.6

KCONFIG		= sunxi
KCONFIG_COMPILE_FLAGS	= zImage sun7i-a20-bananapro.dtb modules
KCONFIG_INSTALL_FLAGS	= INSTALL_MOD_PATH=$(PKG_INSTALL_DIR) modules_install


#
# install kernel
#
KERNEL			= $(PKG_INSTALL_DIR)/boot/vmlinuz

post-install:: $(KERNEL)

$(KERNEL): $(PKG_BUILD_DIR)/arch/arm/boot/zImage $(PKG_BUILD_DIR)/arch/arm/boot/dts/sun7i-a20-bananapro.dtb
	@mkdir -p $(@D)
	@echo "installing kernel to $(KERNEL)"
	@cat $(PKG_BUILD_DIR)/arch/arm/boot/zImage $(PKG_BUILD_DIR)/arch/arm/boot/dts/sun7i-a20-bananapro.dtb > $@.tmp
	@mv $@.tmp $@


clobber::
	@$(call CMD_RM_FILE,$(KERNEL))
