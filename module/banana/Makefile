#
#  
#
SYSROOT_DIR	= /tmp/sysroot
SDCARD_IMG	= Gen/sdcard.img
UBOOT		= $(SYSROOT_DIR)/boot/u-boot.bin
SKELETON_SRCS	= $(shell find skeleton ! -type d | egrep -v '(\~|\#)]' )
INSTALL_DIR	= /tmp


all:: $(SDCARD_IMG)

#
# fixup sysroot and create sdcard
#
$(SDCARD_IMG): $(UBOOT) $(SKELETON_SRCS)
	@mkdir -p $(@D)
	@rm -f $(SYSROOT_DIR)/etc/resolv.conf; ln -s /var/dynamic/resolv.conf $(SYSROOT_DIR)/etc/resolv.conf
	@set -e; for file in $(SKELETON_SRCS:skeleton/%=%); do	\
	    src="skeleton/$$file";			\
	    dst="$(SYSROOT_DIR)/$$file";		\
	    dstdir=`dirname $$dst`;			\
	    if ! cmp -s "$$src" "$$dst"; then		\
		rm -f "$$dst";				\
		mkdir -p "$$dstdir";			\
		( set -ex; cp "$$src" "$$dst" );	\
	    fi;						\
	done
	./bin/sdcard $(SYSROOT_DIR) $(SDCARD_IMG)

clean::
	@find * -type f | egrep '(\~|\#)$$' | xargs -I%% sh -xc 'rm -f %%'
	@rm -rf Gen

install: $(INSTALL_DIR)/sdcard.img

$(INSTALL_DIR)/sdcard.img: $(SDCARD_IMG)
	@mkdir -p $(@D)
	@rm -f $@
	@set -x ; cp $< $@
