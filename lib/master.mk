#
#
#
include $(TLD_ROOT_DIR)/lib/variables.mk

#
# figure out archive name
#
ifneq ($(GIT_ROOT),)
PKG_ARCHIVE_FILE	= $(TLD_CACHE_DIR)/$(PKG_FULLNAME).tar.gz
else ifneq ($(GIT_MODULE),)
PKG_ARCHIVE_FILE	= $(TLD_CACHE_DIR)/$(PKG_FULLNAME).tar.gz
else ifneq ($(PKG_URL),)
PKG_ARCHIVE_FILE	= $(TLD_CACHE_DIR)/$(notdir $(PKG_URL))
endif



#
# generate download rule
#
download:: $(PKG_ARCHIVE_FILE)

$(PKG_ARCHIVE_FILE):
ifneq ($(GIT_ROOT),)
	@mkdir -p $(@D)
	@echo "retrieving archive file $(PKG_ARCHIVE_FILE) using git repository $(GIT_ROOT)"
	@git archive --format=tar.gz -o $@.tmp --remote=$(GIT_ROOT) --prefix=$(PKG_FULLNAME)/ $(VERSION)
	@mv $@.tmp $@
else ifneq ($(GIT_MODULE),)
	@mkdir -p $(@D)
	@echo "retrieving archive file $(PKG_ARCHIVE_FILE) using git module $(GIT_MODULE)"
	@cd $(PKG_MODULE_DIR) ; git archive --format=tar.gz -o $@.tmp --prefix=$(PKG_FULLNAME)/ $(VERSION)
	@mv $@.tmp $@
else ifneq ($(PKG_URL),)
	@mkdir -p $(@D)
	wget -O $@.tmp $(PKG_URL)
	@mv $@.tmp $@
else
	@echo "No PKG_ARCHIVE_FILE defined"
endif



#
# unpack source
#

source:: $(PKG_TIMESTAMP.src)

$(PKG_TIMESTAMP.src):
	@mkdir -p $(@D)
ifneq ($(patsubst %.tar.gz,%,$(PKG_ARCHIVE_FILE)),$(PKG_ARCHIVE_FILE))
	$(CMD_TAR) -xzf $(PKG_ARCHIVE_FILE) -C $(@D) $(CMD_TAR_FLAGS)
else
	@echo "No rule for unpacking to source"
endif
	@touch $@


#
# patch
#
patch:: $(PKG_TIMESTAMP.patch)

$(PKG_TIMESTAMP.patch):
	@mkdir -p $(@D)
	@set -e; for patch in $(wildcard $(PKG_PACKAGE_DIR)/patch/$(PKG_VERSION)/*.patch); do	\
	    ( cd $(PKG_SOURCE_DIR); set -xe ; cat $$patch | patch -p1 );			\
	done
	@touch $@



















#
# configure
#
pre-configure::
post-configure::

configure:: pre-configure $(PKG_TIMESTAMP.cfg) post-configure

$(PKG_TIMESTAMP.cfg):
	@mkdir -p $(@D)
ifneq ($(PKG_KCONFIG),)
ifeq ($(wildcard $(PKG_PACKAGE_DIR)/$(PKG_KCONFIG)),$(PKG_PACKAGE_DIR)/$(PKG_KCONFIG))
	@cp $(PKG_PACKAGE_DIR)/$(PKG_KCONFIG) $(PKG_SOURCE_DIR)/.config
	$(CMD_KCONFIG) -C $(PKG_BUILD_DIR) $(CMD_KCONFIG_CONFIGURE_FLAGS) olddefconfig
else
	$(CMD_KCONFIG) -C $(PKG_BUILD_DIR) $(CMD_KCONFIG_CONFIGURE_FLAGS) $(PKG_KCONFIG)
endif
else ifeq ($(wildcard $(PKG_SOURCE_DIR)/configure),$(PKG_SOURCE_DIR)/configure)
	@cd $(PKG_BUILD_DIR); set -x; $(CMD_CONFIGURE) $(CMD_CONFIGURE_FLAGS)
else ifeq ($(wildcard $(PKG_SOURCE_DIR)/configure.ac),$(PKG_SOURCE_DIR)/configure.ac)
	@cd $(PKG_BUILD_DIR); set -x; autoreconf -vif; $(CMD_CONFIGURE) $(CMD_CONFIGURE_FLAGS)
else
	@echo "No rule configure"
endif
	@touch $@

















#
# compile
#
compile:: $(PKG_TIMESTAMP.compile)

$(PKG_TIMESTAMP.compile):
	@mkdir -p $(@D)
ifneq ($(PKG_KCONFIG),)
	$(CMD_KCONFIG) -C $(PKG_BUILD_DIR) $(CMD_KCONFIG_COMPILE_FLAGS)
else ifeq ($(wildcard $(PKG_SOURCE_DIR)/configure),$(PKG_SOURCE_DIR)/configure)
	$(CMD_SUBMAKE) -C $(PKG_BUILD_DIR) $(CMD_SUBMAKE_COMPILE_FLAGS)
else ifeq ($(wildcard $(PKG_BUILD_DIR)/Makefile),$(PKG_BUILD_DIR)/Makefile)
	$(CMD_SUBMAKE) -C $(PKG_BUILD_DIR) $(CMD_SUBMAKE_COMPILE_FLAGS)
else
	@echo "No rule to compile"
endif
	@touch $@

















#
# if package has opkg/control, we build an ipk
#
pacman::

ifeq ($(wildcard $(PKG_PACKAGE_DIR)/opkg/control),$(PKG_PACKAGE_DIR)/opkg/control)
pacman:: $(TLD_ROOT_DIR)/opkg/$(PKG_FULLNAME).ipk

$(TLD_ROOT_DIR)/opkg/$(PKG_FULLNAME).ipk:
	@mkdir -p $(PKG_STAGE_DIR)/CONTROL $(TLD_PACMAN_DIR)
	@cp $(PKG_PACKAGE_DIR)/opkg/* $(PKG_STAGE_DIR)/CONTROL
	@$(TLD_TOOLS_DIR)/usr/bin/opkg-build -o 0 -g 0 $(PKG_STAGE_DIR) $(TLD_PACMAN_DIR)
endif





#
# install
#
post-install::

install:: $(PKG_TIMESTAMP.install) post-install pacman

$(PKG_TIMESTAMP.install):
	@mkdir -p $(@D)
ifneq ($(CUSTOM_INSTALL),)
	@echo "custom install for package $(PKG_FULLNAME)"
else ifneq ($(PKG_KCONFIG),)
	$(CMD_KCONFIG) -C $(PKG_BUILD_DIR) $(CMD_KCONFIG_INSTALL_FLAGS)
else ifeq ($(wildcard $(PKG_SOURCE_DIR)/configure),$(PKG_SOURCE_DIR)/configure)
	$(CMD_SUBMAKE) -C $(PKG_BUILD_DIR) $(CMD_SUBMAKE_INSTALL_FLAGS) DESTDIR=$(PKG_INSTALL_DIR) install
else ifeq ($(wildcard $(PKG_BUILD_DIR)/Makefile),$(PKG_BUILD_DIR)/Makefile)
	$(CMD_SUBMAKE) -C $(PKG_BUILD_DIR) $(CMD_SUBMAKE_INSTALL_FLAGS)
else
	@echo "No rule to install"
endif
	@touch $@


#
#
#
clean::
	@$(call CMD_RM_DIR,$(PKG_SOURCE_DIR))
	@$(call CMD_RM_DIR,$(PKG_BUILD_DIR))

clobber:: clean
	@$(call CMD_RM_FILE,$(PKG_ARCHIVE_FILE))
