DEFAULT_PREFERENCE = "-1"

include gstreamer1.0-omx.inc

LIC_FILES_CHKSUM = "file://COPYING;md5=4fbd65380cdd255951079008b364516c \
                    file://omx/gstomx.h;beginline=1;endline=21;md5=5c8e1fca32704488e76d2ba9ddfa935f"

SRC_URI = " \
    git://anongit.freedesktop.org/gstreamer/gst-omx;branch=master;name=gst-omx \
    git://anongit.freedesktop.org/gstreamer/common;destsuffix=git/common;branch=master;name=common \
"

SRCREV_gst-omx = "b4c7c726ef443cf8a89df26026706e391846bb4a"
SRCREV_common = "1f5d3c3163cc3399251827235355087c2affa790"

SRCREV_FORMAT = "gst-omx"

S = "${WORKDIR}/git"

do_configure_prepend() {
	cd ${S}
	./autogen.sh --noconfigure
	cd ${B}
}
