DESCRIPTION = "enable /dev/mmcblk0p3 as USB stick on host"

LICENSE = "CLOSED"
SRC_URI = "file://usbdisk.sh"

do_configure(){
   :
}

do_install () {
   install -d ${D}${sbindir}
   install ${WORKDIR}/usbdisk.sh ${D}${sbindir}
}
