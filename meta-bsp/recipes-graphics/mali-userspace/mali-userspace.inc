SECTION = "libs"
LICENSE = "Proprietary-Samsung"
LIC_FILES_CHKSUM_append = "file://${SAMSUNG_LICENSE_FILE};md5=de3ae16b0f384e99b27645b262903ce2"
COMPATIBLE_MACHINE = "automotive-samsung-e8"

DEPENDS += "${@base_contains("DISTRO_FEATURES", "wayland", " mesa", " ", d)}"

PROVIDES += "virtual/egl virtual/libgles1 virtual/libgles2 virtual/libopencl"
PROVIDES += "${@base_contains("DISTRO_FEATURES", "wayland", " virtual/libwayland-egl", " ", d)}"


S = "${WORKDIR}"

INSANE_SKIP_${PN} = "ldflags dev-so"

INHIBIT_PACKAGE_DEBUG_SPLIT = "1"
INHIBIT_PACKAGE_STRIP = "1"

USE_X11 = "${@base_contains("DISTRO_FEATURES", "x11", "yes", "no", d)}"
USE_DFB = "${@base_contains("DISTRO_FEATURES", "directfb", "yes", "no", d)}"
USE_WL = "${@base_contains("DISTRO_FEATURES", "wayland", "yes", "no", d)}"

do_configure[noexec] = "1"
do_compile[noexec] = "1"

do_install () {
	# Create MALI manifest
	install -m 755 -d ${D}/${libdir}
	if [ "${USE_X11}" = "yes" ]; then
		install ${S}/libmali.so ${D}/${libdir}
		install ${S}/libmali-gbm.so ${D}/${libdir}
	elif [ "${USE_WL}" = "yes" ]; then
		install ${S}/libmali.so ${D}/${libdir}
		install ${S}/libmali-gbm.so ${D}/${libdir}
	else
		install ${S}/libmali.so ${D}/${libdir}
		install ${S}/libmali-gbm.so ${D}/${libdir}
	fi

	ln -sf libmali.so ${D}/${libdir}/libEGL.so
	ln -sf libmali.so ${D}/${libdir}/libGLESv1_CM.so
	ln -sf libmali.so ${D}/${libdir}/libGLESv2.so
	ln -sf libmali.so ${D}/${libdir}/libOpenCL.so
	if [ "${USE_WL}" = "yes" ]; then
		ln -sf libmali-gbm.so ${D}/${libdir}/libgbm.so
		ln -sf libmali-gbm.so ${D}/${libdir}/libwayland-egl.so
	fi
	
	ln -sf libmali.so ${D}/${libdir}/libegl-mali.so
}

PACKAGES = "${PN}"
FILES_${PN} += "${libdir}/*.so"

RREPLACES_${PN} = "libegl libegl1 libgles1 libglesv1-cm1 libgles2 libglesv2-2 libgbm libegl-mali"
RPROVIDES_${PN} = "libegl libegl1 libgles1 libglesv1-cm1 libgles2 libglesv2-2 libgbm libegl-mali"
RCONFLICTS_${PN} = "libegl libegl1 libgles1 libglesv1-cm1 libgles2 libglesv2-2 libgbm libegl-mali"

