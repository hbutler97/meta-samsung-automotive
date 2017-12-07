FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

GSTREAMER_1_0_OMX_TARGET_automotive-samsung-e8 = "exynos"
GSTREAMER_1_0_OMX_CORE_NAME_automotive-samsung-e8 = "/usr/lib/libExynosOMX_Core.so"
PACKAGE_ARCH = "${MACHINE_ARCH}"

RDEPENDS_${PN}_delete = "libEGL"
RDEPENDS_${PN}_append += "libegl-mali"

SRC_URI += "file://0001-exynos-add-plugin-for-exynos.patch \
            file://0002-exynos-add-mpeg4dec-and-wmvdec.patch \
           "
