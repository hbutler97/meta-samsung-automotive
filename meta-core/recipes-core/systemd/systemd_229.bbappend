FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI += "file://0001-udev-part-id-handle-i2c-subsystem.patch"
SRC_URI += "file://0002-core-manager-Change-max-timeout-no-limit-to-1min-30s.patch"

PACKAGE_BEFORE_PN_append = " ${PN}-getty"

FILES_${PN}-getty = "${sysconfdir}/systemd/system/getty.target.wants/getty@*.service"

