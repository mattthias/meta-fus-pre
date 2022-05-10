# Copyright (C) 2020 F&S Elektronik Systeme GmbH
# Released under the GPLv2 license
#Prevent Kernel from beeing nstalled to the rootfs
kernel_do_install() {
	#
	# First install the modules
	#
	unset CFLAGS CPPFLAGS CXXFLAGS LDFLAGS MACHINE
	if (grep -q -i -e '^CONFIG_MODULES=y$' .config); then
		oe_runmake DEPMOD=echo MODLIB=${D}${nonarch_base_libdir}/modules/${KERNEL_VERSION} INSTALL_FW_PATH=${D}${nonarch_base_libdir}/firmware modules_install
		rm "${D}${nonarch_base_libdir}/modules/${KERNEL_VERSION}/build"
		rm "${D}${nonarch_base_libdir}/modules/${KERNEL_VERSION}/source"
		# If the kernel/ directory is empty remove it to prevent QA issues
		rmdir --ignore-fail-on-non-empty "${D}${nonarch_base_libdir}/modules/${KERNEL_VERSION}/kernel"
	else
		bbnote "no modules to install"
	fi

	#
	# Install various kernel output (zImage, map file, config, module support files)
	#

	install -d ${D}/boot

	install -m 0644 System.map ${D}/boot/System.map-${KERNEL_VERSION}
	install -m 0644 .config ${D}/boot/config-${KERNEL_VERSION}
	install -m 0644 vmlinux ${D}/boot/vmlinux-${KERNEL_VERSION}
	[ -e Module.symvers ] && install -m 0644 Module.symvers ${D}/boot/Module.symvers-${KERNEL_VERSION}
	install -d ${D}${sysconfdir}/modules-load.d
	install -d ${D}${sysconfdir}/modprobe.d
}

# rename kernel image to be confirmed with naming convention
# for iMX8M based boards
kernel_do_deploy_append_mx8m() {
	# Set soft link to the kernel image and remove not needed links.
    # Use conform naming to documentation.
	cd ${DEPLOYDIR}
	ln -sf Image-${KERNEL_IMAGE_NAME}.bin Image-${MACHINE}
	rm -f Image-${MACHINE}.bin
	cd -
}