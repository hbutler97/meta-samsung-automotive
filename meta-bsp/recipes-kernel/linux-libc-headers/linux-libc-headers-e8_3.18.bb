require recipes-kernel/linux-libc-headers/linux-libc-headers.inc
require recipes-kernel/linux/linux-samsung-e8.inc
PROVIDES += "linux-libc-headers"
RPROVIDES_${PN}-dev += "linux-libc-headers-dev"
RPROVIDES_${PN}-dbg += "linux-libc-headers-dbg"

#SRC_URI = "file://${DL_DIR}/linux-samsung-e8.tar.gz"

SRC_URI = "git://github.com/hbutler97/linux_samsung.git;rev=403918a500424cc8ac763b9ef5844e0ccd5f9221"


S = "${WORKDIR}/linux-samsung-e8"
B = "${S}"

do_configure() {
	oe_runmake_call -C ${S} O=${B} ${KDEFCONFIG}
}

do_tar_files() {
  if [ ! -f ${DL_DIR}/linux-samsung-e8.tar.gz ]
  then
    cat ${WORKDIR}/git/linux-samsung-e8* > ${DL_DIR}/linux-samsung-e8.tar.gz
  fi
  tar xvf ${DL_DIR}/linux-samsung-e8.tar.gz -C ${WORKDIR}	
}

addtask tar_files after do_unpack before do_patch
