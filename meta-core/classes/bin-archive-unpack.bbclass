# Unpack a tarball from premirror location and copies
# all its content into destination folder (UNPACK_TARGET).
#

#
# Configuration settings
#
FILESEXTRAPATHS_prepend := "${DEPLOY_DIR_BIN_ARCHIVES}:${THISDIR}/${PN}:"
# Target definitions to unpack; TODO crosssdk etc.
UNPACK_TARGET ?= "${D}"
UNPACK_TARGET_class-native ?= "${D}${STAGING_DIR_NATIVE}"
UNPACK_TARGET_class-nativesdk ?= "${D}${base_prefix}"
# Common settings
LIC_FILE_NAME ?= "COPYING"
do_configure[noexec] = "1"
do_compile[noexec] = "1"
# to avoid QA error
#     'Files/directories were installed but not shipped'
#     '/patches'
# see base.bblass do_unpack[cleandirs] = "${S}\patches"
do_unpack[cleandirs] = "${S}"


do_install(){
    cd ${WORKDIR}
    install -d ${UNPACK_TARGET}
    cp -rpf ${S}/* ${UNPACK_TARGET}
    rm -f ${UNPACK_TARGET}/${LIC_FILE_NAME}
}
