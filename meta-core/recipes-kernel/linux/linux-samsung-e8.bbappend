FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI_append += "\
      file://ikconfig.scc \
      "
KERNEL_FEATURES_append += "ikconfig.scc"

