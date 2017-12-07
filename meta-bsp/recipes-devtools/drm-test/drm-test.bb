DESCRIPTION = "DRM mode test utility"
LICENSE="CLOSED"

PROVIDES = "drm-test"

inherit allarch

SRC_URI = " \
   file://modetest \
"

do_configure[noexec] = "1"
do_compile[noexec] = "1"

# to skip QA Issue: Architecture did not match
INSANE_SKIP_${PN} = "arch"

INHIBIT_PACKAGE_DEBUG_SPLIT = "1"
INHIBIT_PACKAGE_STRIP = "1"

do_install () {
    install -d ${D}${bindir_native}
    install -m 755 ${WORKDIR}/modetest ${D}${bindir_native}/modetest
}

PACKAGES = "${PN}"
FILES_${PN} = "/"

