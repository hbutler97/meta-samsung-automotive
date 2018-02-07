require recipes-kernel/linux-libc-headers/linux-libc-headers.inc
require recipes-kernel/linux/linux-samsung-e8.inc
PROVIDES += "linux-libc-headers"
RPROVIDES_${PN}-dev += "linux-libc-headers-dev"
RPROVIDES_${PN}-dbg += "linux-libc-headers-dbg"

#SRC_URI = "file://${DL_DIR}/linux-samsung-e8.tar.gz"

SRC_URI = "http://github.com/SSIC-SM/linux-samsung-e8.git;rev=d859009a7ff589182ee007d1e2f43e114dacb336"
#SRCREV = "${AUTOREV}"


S = "${WORKDIR}/linux-samsung-e8"
B = "${S}"

do_configure() {
	oe_runmake_call -C ${S} O=${B} ${KDEFCONFIG}
}


