FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI += "file://0001-inotify06-is-a-regression-test-for-kernels-4.2.patch \
	    file://0002-Clean-up-unnecessary-Test-Cases-by-default.patch \
"
