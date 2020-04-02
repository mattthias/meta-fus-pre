# Copyright (C) 2016 F&S Elektronik Systeme GmbH
# Released under the GPLv2 license

LICENSE = "GPLv2"
LIC_FILES_CHKSUM = "file://COPYING;md5=d7810fab7487fb0aad327b76f1be7cd7"

inherit kernel

SUMMARY = "Linux Kernel for F&S i.MX8-based boards and modules"

DEPENDS += "lzop-native bc-native"

COMPATIBLE_MACHINE = "(mx8)"

SRC_URI = "file://linux-4.14.98-fus.tar.bz2"
S = "${WORKDIR}/linux-4.14.98-fus"

# We need to pass it as param since kernel might support more then one
# machine, with different entry points
KERNEL_EXTRA_ARGS += "LOADADDR=${UBOOT_ENTRYPOINT}"

FSCONFIG_mx8mm = "fsimx8mm_defconfig"

# Prevent the galcore-module from beeing build, because it is already
# included in the F&S-Linux-Kernel as a build-in
RPROVIDES_kernel-image += "kernel-module-imx-gpu-viv"

do_extraunpack () {
	mv ${WORKDIR}/linux-fus/* ${S}/
}


kernel_do_configure_prepend() {
	install -m 0644 ${S}/arch/${ARCH}/configs/${FSCONFIG} ${WORKDIR}/defconfig
}
