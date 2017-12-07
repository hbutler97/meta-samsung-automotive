
# to fix ext4 issue (2016/10/20)
do_image_fsck_ext4() {
	echo "Checking EXT4 filesystem...."
	cd ${DEPLOY_DIR_IMAGE}
	e2fsck -fy ${IMAGE_LINK_NAME}.ext4 || :
}
addtask do_image_fsck_ext4 after do_image_ext4 before do_image_tar
