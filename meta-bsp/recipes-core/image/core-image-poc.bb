inherit core-image
DESCRIPTION = "SAMSUNG Automotive image"

DISTRO = "sel-automotive"
MACHINE = "automotive-samsung-e8"

##IMAGE_FEATURES_append = " read-only-rootfs"
REQUIRED_DISTRO_FEATURES = "systemd"
TOOLCHAIN_HOST_TASK_append = " nativesdk-cmake"

#IMAGE_FEATURES_append = " debug-tweaks ssh-server-openssh  allow-empty-password empty-root-password  hwcodecs tools-audio package-management xswayland"
IMAGE_FEATURES_append = " debug-tweaks ssh-server-openssh  allow-empty-password empty-root-password  hwcodecs package-management"

REQUIRED_DISTRO_FEATURES_remove = "x11"
TOOLCHAIN_HOST_TASK_append = " nativesdk-cmake"

##SYSTEMD_DEFAULT_TARGET = "graphical.target"
##SYSTEMD_AUTO_ENABLE_xs-window-switcher = "enable"
##SRC_URI += "file://touchscreen.conf;subdir=${BP}"


##CORE_IMAGE_EXTRA_INSTALL_append = " \
##		packagegroup-base-serial \
##		packagegroup-base-usbhost \
##		exynos-firmware \
##		kernel-modules \
##		fbset \
##		fbset-modes \
##		fbgrab \
##		e2fsprogs-e2fsck \
##		e2fsprogs-mke2fs \
##		pciutils \
##		dosfstools \
##		usbdisk \
##		gptfdisk \
##"

##CORE_IMAGE_EXTRA_INSTALL_append = " \
##	packagegroup-base-serial \
##	packagegroup-base-usbhost \
##	gstreamer1.0-omx \
##	gstreamer1.0-libav \
##	gstreamer1.0-plugins-base-meta \
##	gstreamer1.0-plugins-good-meta \
##	gstreamer1.0-plugins-bad-meta \
##	fbset \
##	fbgrab \
##	pciutils \
##	dosfstools \
##	alsa-utils-speakertest \
##	alsa-utils \
##	alsa-utils-alsamixer \
##	alsa-utils-midi \
##	alsa-utils-aplay \
##	alsa-utils-amixer \
##	alsa-utils-aconnect \
##	alsa-utils-iecset \
##	alsa-utils-speakertest \
##	alsa-utils-aseqnet \
##	alsa-utils-aseqdump \
##	alsa-utils-alsactl \
##	alsa-utils-alsaloop \
##	alsa-utils-alsaucm \
##	usbdisk \
##	wayland-clients \
##	xswayland-clients \
##	gptfdisk \
##	e2fsprogs-e2fsck \
##	e2fsprogs-mke2fs \
##	osg-wayland \
##	xs-window-switcher \
##	urbanbench \
##	pci-demo \
##	glmark2 \
##	exynos-firmware \
##	early-boot \
##	kernel-modules \
##	"

IMAGE_FEATURES_remove = "x11-base x11 codebench-debug tools-profile"


# to fix ext4 issue (2016/10/20)
do_image_fsck_ext4() {
	echo "Checking EXT4 filesystem...."
	cd ${DEPLOY_DIR_IMAGE}
	e2fsck -fy ${IMAGE_LINK_NAME}.ext4 || :
}
addtask do_image_fsck_ext4 after do_image_ext4 before do_image_tar
