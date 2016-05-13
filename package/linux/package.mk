#
# build linux - 
#
GIT_MODULE	= linux
VERSION		= v4.4.6

KCONFIG		= sunxi
KCONFIG_COMPILE_FLAGS	= LOADADDR=40008000 uImage sun7i-a20-bananapro.dtb modules
KCONFIG_INSTALL_FLAGS	= INSTALL_MOD_PATH=$(PKG_INSTALL_DIR) modules_install


#
# install kernel
#
KERNEL			= $(PKG_INSTALL_DIR)/boot/vmlinuz
DTB			= $(PKG_INSTALL_DIR)/boot/dts/sun7i-a20-bananapro.dtb

post-install:: $(KERNEL)

$(KERNEL): $(PKG_BUILD_DIR)/arch/arm/boot/zImage
	@mkdir -p $(@D)
	@echo "installing kernel to $@"
	@cp $< $@

$(DTB): $(PKG_BUILD_DIR)/arch/arm/boot/dts/sun7i-a20-bananapro.dtb
	@mkdir -p $(@D)
	@echo "installing device tree to $@"
	@cp $< $@

clobber::
	@$(call CMD_RM_FILE,$(KERNEL))
	@$(call CMD_RM_FILE,$(DTB))
