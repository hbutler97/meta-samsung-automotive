DESCRIPTION = "Exynos demo videos"
LICENSE="CLOSED"

inherit systemd
SRC_URI = " \
   file://r8.mp4 \
   file://video.service \
   file://test.sh \
   "

do_configure[noexec] = "1"
do_compile[noexec] = "1"

do_install () {
   install -d ${D}${datadir}/exynos-video-demo ${D}/${systemd_unitdir}/system ${D}${ROOT_HOME}
   install ${WORKDIR}/r8.mp4 ${D}${datadir}/exynos-video-demo
   install ${WORKDIR}/video.service ${D}/${systemd_unitdir}/system
   install ${WORKDIR}/test.sh ${D}${ROOT_HOME}
   chmod a+x ${D}${ROOT_HOME}/test.sh

}

SYSTEMD_SERVICE_${PN} = "video.service"
SYSTEMD_AUTO_ENABLE ?= "enable"

PACKAGES = "${PN}"
FILES_${PN} = "/"
