DESCRIPTION = "Andorid ADB tool for embedded linux"
LICENSE="CLOSED"

PROVIDES = "android-adb"

inherit allarch

SRC_URI = " \
   file://adbd \
   file://adb.sh \
"

do_configure[noexec] = "1"
do_compile[noexec] = "1"

# to skip QA Issue: Architecture did not match
INSANE_SKIP_${PN} = "arch"

INHIBIT_PACKAGE_DEBUG_SPLIT = "1"
INHIBIT_PACKAGE_STRIP = "1"

do_install () {
    install -d ${D}${bindir_native}
    install -d ${D}${ROOT_HOME}    
    install ${WORKDIR}/adbd ${D}${bindir_native}/adbd
    install -m 0755 ${WORKDIR}/adb.sh ${D}${ROOT_HOME}
}

PACKAGES = "${PN}"
FILES_${PN} = "/"

