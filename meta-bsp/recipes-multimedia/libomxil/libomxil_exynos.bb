SUMMARY = "Exynos OpenMAX Integration Layer (IL)"
LICENSE = "Apache-2.0"
SRC_URI = "file://libomxil_${PV}.tar.gz;subdir=${BP}"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/Apache-2.0;md5=89aea4e17d99a7cacdbeed46a0096b10"

inherit cmake
PACKAGE_ARCH = "${MACHINE_ARCH}"
PROVIDES += "libomxil"

CFLAGS_append = " -fPIC "

FILES_${PN}-dev = "${includedir}"
FILES_${PN} += "${libdir}/*.so"
