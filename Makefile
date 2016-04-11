#
# top level makefile parses the target and call master.mk.
#
TLD_ROOT_DIR		= $(realpath .)
TLD_VERBOSE		=

include $(TLD_ROOT_DIR)/lib/variables.mk


# host-toolchain

PACKAGES	= host-toolchain basefs host-opkg host-opkg-utils linux u-boot banana

world::	$(PACKAGES)

SUBMAKE_FLAGS	= -f $(TLD_MASTER_MAKEFILE) TLD_ROOT_DIR=$(TLD_ROOT_DIR) TLD_VERBOSE=$(V)

%-download:
	@$(CMD_SUBMAKE) $(SUBMAKE_FLAGS) PACKAGE=$(patsubst %-download,%,$@) download

%-source: %-download
	@$(CMD_SUBMAKE) $(SUBMAKE_FLAGS) PACKAGE=$(patsubst %-source,%,$@) source

%-patch: %-source
	@$(CMD_SUBMAKE) $(SUBMAKE_FLAGS) PACKAGE=$(patsubst %-patch,%,$@) patch

%-configure: %-patch
	@$(CMD_SUBMAKE) $(SUBMAKE_FLAGS) PACKAGE=$(patsubst %-configure,%,$@) configure

%-compile: %-configure
	@$(CMD_SUBMAKE) $(SUBMAKE_FLAGS) PACKAGE=$(patsubst %-compile,%,$@) compile

%-install: %-compile
	@$(CMD_SUBMAKE) $(SUBMAKE_FLAGS) PACKAGE=$(patsubst %-install,%,$@) install

%-clean:
	@$(CMD_SUBMAKE) $(SUBMAKE_FLAGS) PACKAGE=$(patsubst %-clean,%,$@) clean

%-clobber: %-clean
	@$(CMD_SUBMAKE) $(SUBMAKE_FLAGS) PACKAGE=$(patsubst %-clobber,%,$@) clobber


#
# clean
#
clean::
	@$(call CMD_RM_DIR,$(TLD_OBJECT_DIR))
	@find * -type f | egrep '(\~|\#)$$' | xargs -I%% sh -xc 'rm -f %%'

#
# remove everything
#
clobber:: clean
	@$(call CMD_RM_DIR,$(TLD_TOOLS_DIR))
	@$(call CMD_RM_DIR,$(TLD_SYSROOT_DIR))
	@$(call CMD_RM_FILE,$(TLD_ROOT_DIR)/sdcard.img)

#
# if specify a target, build the package
#
.DEFAULT:
	$(CMD_SUBMAKE) $@-install

