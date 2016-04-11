#
# variables for TLD
#
TLD_LIB_DIR		= $(TLD_ROOT_DIR)/lib
TLD_PACKAGE_DIR		= $(TLD_ROOT_DIR)/package
TLD_MODULE_DIR		= $(TLD_ROOT_DIR)/module
TLD_OBJECT_DIR		= $(TLD_ROOT_DIR)/Gen
TLD_BUILD_DIR		= $(TLD_OBJECT_DIR)/build
TLD_CACHE_DIR		= /banana/download
TLD_STAGE_DIR		= $(TLD_OBJECT_DIR)/stage
TLD_PACMAN_DIR		= $(TLD_ROOT_DIR)/opkg

TLD_MASTER_MAKEFILE	= $(TLD_LIB_DIR)/master.mk

#
#
#
CFG_TARGET_ARCH		= arm
CFG_TARGET_GCC		= arm-linux
CFG_CROSS_COMPILE	= $(TLD_TOOLS_DIR)/usr/bin/$(CFG_TARGET_GCC)-

#
# variables for rootfs
#
TLD_SYSROOT_DIR		= /banana/sysroot

#
# cross tools dir
#
TLD_TOOLS_DIR		= /banana/tools/sunxi

#
# just the compiler
#
TLD_TOOLCHAIN_DIR	= $(subst tools,toolchain,$(TLD_TOOLS_DIR))

#
# package
#
ifneq ($(PACKAGE),)
PKG_PACKAGE_DIR		= $(TLD_PACKAGE_DIR)/$(PACKAGE)

PKG_VERSION	= $(subst /,-,$(VERSION))
PKG_NAME	= $(notdir $(PACKAGE))
PKG_FULLNAME	= $(PKG_NAME)-$(PKG_VERSION)

ifeq ($(PKG_BUILD_DIR),)
PKG_BUILD_DIR	= $(TLD_BUILD_DIR)/$(PKG_FULLNAME)
endif

ifeq ($(PKG_SOURCE_DIR),)
PKG_SOURCE_DIR	= $(PKG_BUILD_DIR)
endif

PKG_STAGE_DIR	= $(TLD_STAGE_DIR)/$(PKG_FULLNAME)

PKG_TIMESTAMP.src		= $(PKG_SOURCE_DIR)/.timestamp.src
PKG_TIMESTAMP.patch		= $(PKG_SOURCE_DIR)/.timestamp.patch
PKG_TIMESTAMP.cfg		= $(PKG_BUILD_DIR)/.timestamp.cfg
PKG_TIMESTAMP.compile		= $(PKG_BUILD_DIR)/.timestamp.compile
PKG_TIMESTAMP.install		= $(PKG_BUILD_DIR)/.timestamp.install
PKG_TIMESTAMP.post-cfg		= $(PKG_BUILD_DIR)/.timestamp.post-cfg
PKG_TIMESTAMP.post-install	= $(PKG_BUILD_DIR)/.timestamp.post-install

ifeq ($(wildcard $(PKG_PACKAGE_DIR)/opkg/control),$(PKG_PACKAGE_DIR)/opkg/control)
PKG_INSTALL_DIR		= $(PKG_STAGE_DIR)
else ifeq ($(patsubst host-%,%,$(PACKAGE)),$(PACKAGE))
PKG_INSTALL_DIR		= $(TLD_SYSROOT_DIR)
else
PKG_INSTALL_DIR		= $(TLD_TOOLS_DIR)
endif

ifeq ($(wildcard $(PKG_PACKAGE_DIR)/package.mk), $(PKG_PACKAGE_DIR)/package.mk)
include $(PKG_PACKAGE_DIR)/package.mk
else
$(error "failed to find makefile for package $(PACKAGE)")
endif


ifneq ($(GIT_MODULE),)
PKG_MODULE_DIR		= $(TLD_MODULE_DIR)/$(GIT_MODULE)
endif


ifneq ($(KCONFIG),)
ifeq ($(subst defconfig,,$(KCONFIG)),$(KCONFIG))
PKG_KCONFIG	= $(KCONFIG)_defconfig
else
PKG_KCONFIG	= $(KCONFIG)
endif
endif

PKG_URL		= $(URL)

endif

include $(TLD_LIB_DIR)/commands.mk
