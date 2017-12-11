# This file was derived from the linux-samsung-e8.bb recipe in
# oe-core.
#
# linux-samsung-e8.bb:
#
#   A yocto-bsp-generated kernel recipe that uses the linux-yocto and
#   oe-core kernel classes to apply a subset of yocto kernel
#   management to git managed kernel repositories.
#
# Warning:
#
#   Building this kernel without providing a defconfig or BSP
#   configuration will result in build or boot errors. This is not a
#   bug.
#
# Notes:
#
#   patches: patches can be merged into to the source git tree itself,
#            added via the SRC_URI, or controlled via a BSP
#            configuration.
#
#   example configuration addition:
#            SRC_URI += "file://smp.cfg"
#   example patch addition:
#            SRC_URI += "file://0001-linux-version-tweak.patch
#   example feature addition:
#            SRC_URI += "file://feature.scc"
#

inherit kernel
require recipes-kernel/linux/linux-samsung-e8.inc
require recipes-kernel/linux/linux-dtb.inc

SECTION = "kernel"
LICENSE = "GPLv2"
LIC_FILES_CHKSUM = "file://COPYING;md5=d7810fab7487fb0aad327b76f1be7cd7"

KERNEL_RAM_BASE = "0x80008000"
RAMDISK_RAM_BASE = "0x81000000"
SECOND_RAM_BASE = "0x80f00000"
TAGS_RAM_BASE = "0x80000100"
BOOT_PARTITION = "/dev/mmcblk0p2"

EXTRA_OEMAKE_append = " V=1"
KERNEL_CC_append = " --sysroot=${STAGING_DIR_TARGET}"


do_configure_prepend() {
export KBUILD_SRC=${S}
rm -f ${B}/.config ${S}/.config
}


do_tar_files() {
cat ${WORKDIR}/git/linux-samsung-e8* > ${DL_DIR}/linux-samsung-e8.tar.gz
}

addtask tar_files after do_unpack before do_patch




# Select Xen for virtualization
def get_xen(d):
    if d.getVar('AUTOMOTIVE_VIRTUAL_PROJECT',True):
        return "xen"
    else:
        return ""
DEPENDS += " ${@get_xen(d)}"