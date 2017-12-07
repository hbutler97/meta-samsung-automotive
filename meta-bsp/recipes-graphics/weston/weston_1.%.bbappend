FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI += "file://0001-Modified-link-option-for-gl-renderer-to-enable-mali.patch \
            file://0002-HACK-change-refresh-value-to-60000-60Hz.patch \
            file://0001-weston-libinput-seat-enable-weston-backend-even-if-n.patch \
"
RDEPENDS_${PN} += "mali-userspace-t8xx"
