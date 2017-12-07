
V4L_TESTAPPS ?= " \
   yavta \
   v4l-utils \
   imagemagick \
   "
FS_UTILS ?= "\
   util-linux-fdisk \
   util-linux-fsck \
   util-linux-fstrim \
   util-linux-mkfs \
   "
CORE_UTILS ?= "\
   findutils \
   gzip \
   tar \
   bzip2 \
   xz \
   lrzsz \
   i2c-tools \
   spitools \
   devmem2 \
   coreutils \
   "

RDEPENDS_${PN} += "\
   ${@bb.utils.contains('MACHINE_FEATURES', 'pci', 'pciutils', '',  d)} \
   ${@bb.utils.contains('MACHINE_FEATURES', 'usbhost', 'usbutils', '',  d)} \
   ${@bb.utils.contains('MACHINE_FEATURES', 'can', 'can-utils', '',  d)} \
   ${@bb.utils.contains('MACHINE_FEATURES', 'ethernet', 'net-tools', '',  d)} \
   ${V4L_TESTAPPS} \
   ${CORE_UTILS} \
   ${FS_UTILS} \
   "
   
