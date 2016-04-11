#
# commands used. it generally has the following forms
#
#    CMD_{COMMAND_NAME}		- the command 
#    CMD_{COMMAND_NAME}_FLAGS	- flags for the commnad. it generally include package provided flag {COMMAND_NAME}_FLAGS
#


#
# make 
#
CMD_SUBMAKE_COMPILE_FLAGS	= $(SUBMAKE_COMPILE_FLAGS)
CMD_SUBMAKE_INSTALL_FLAGS	= $(SUBMAKE_INSTALL_FLAGS)
CMD_SUBMAKE			= make

#
# remove 
#
CMD_RM_FILE			= if [ "$(1)" != "" -a -f "$(1)" ]; then set -x; rm -f "$(1)"; fi
CMD_RM_DIR			= if [ "$(1)" != "" -a -d "$(1)" ]; then set -x; rm -rf "$(1)"; fi

#
# for projects that uses Kconfig
#
CMD_KCONFIG_FLAGS		= ARCH=$(CFG_TARGET_ARCH) CROSS_COMPILE=$(CFG_CROSS_COMPILE)
CMD_KCONFIG_CONFIGURE_FLAGS	= $(CMD_KCONFIG_FLAGS) $(KCONFIG_CONFIGURE_FLAGS)
CMD_KCONFIG_COMPILE_FLAGS	= $(CMD_KCONFIG_FLAGS) $(KCONFIG_COMPILE_FLAGS)
CMD_KCONFIG_INSTALL_FLAGS	= $(CMD_KCONFIG_FLAGS) $(KCONFIG_INSTALL_FLAGS)
CMD_KCONFIG			= make

#
# for unpacking tarball to builddir
#
CMD_TAR_STRIP_COMPONENT		= 1
CMD_TAR_FLAGS			= --strip-components=1
CMD_TAR				= tar

#
# for project that uses configure
#
CMD_CONFIGURE_HOST_FLAGS	=
CMD_CONFIGURE_TARGET_FLAGS	= CC=$(CFG_CROSS_COMPILE)gcc
ifneq ($(patsubst host-%,%,$(PACKAGE)),$(PACKAGE))
CMD_CONFIGURE_ARCH_FLAGS	= $(CMD_CONFIGURE_HOST_FLAGS)
else
CMD_CONFIGURE_ARCH_FLAGS	= $(CMD_CONFIGURE_TARGET_FLAGS)
endif

CMD_CONFIGURE_FLAGS		= --prefix=/usr --host=$(shell uname -m)
CMD_CONFIGURE			= env $(CMD_CONFIGURE_ARCH_FLAGS) $(PKG_SOURCE_DIR)/configure
