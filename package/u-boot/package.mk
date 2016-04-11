GIT_MODULE	= u-boot
VERSION		= v2016.01

KCONFIG		= Bananapro
CUSTOM_INSTALL	= 1


#
# cp bootloader to sysroot/boot/u-boot.bin
#
post-install:: $(TLD_SYSROOT_DIR)/boot/u-boot.bin

$(TLD_SYSROOT_DIR)/boot/u-boot.bin: $(PKG_BUILD_DIR)/u-boot-sunxi-with-spl.bin
	@mkdir -p $(@D)
	@set -x ; cp $< $@
