# This archive is designate for for re-use with unpack class.
# Its stored a downaloads for and used at a premirror location for example. 
#
# To enable it use
# BIN_ARCHIVE_ENABLE ?= "1"
#
# Addtional it creates an include file containing relevant infos
# for unpack class. This mechanism requires that building from source
# is done by ${PN}_${PV}-src.bb and using prebuilt archive by ${PN}_${PV}.bb
# 
inherit package archive-release-downloads packagedata ${PACKAGE_CLASSES}

do_check_for_license_file[doc] = "[bin-archive-pack] Ensures there is a license file."

# Configuration settings
#
# Binary archive definitions.
BINARY_ARTIFACTS_COMPRESSION ?= ".gz"
BIN_PKGKV ?= "${@d.getVar('PV', True).replace('AUTOINC+', '')}"
BIN_ARCHIVE_NAME ?= "${PN}-bin_${BIN_PKGKV}_${PACKAGE_ARCH}"
BIN_ARCHIVE_FILE ?= "${BIN_ARCHIVE_NAME}.tar${BINARY_ARTIFACTS_COMPRESSION}"
BIN_ARCHIVE_FILE_EXCLUDED ?= "${BIN_ARCHIVE_NAME}-excluded.tar${BINARY_ARTIFACTS_COMPRESSION}"
BIN_ARCHIVE_TARGET ?= "${DL_DIR}"
BIN_ARCHIVE_MIRROR ?= "file://"
BINARY_INSANE_SKIP ?= ""
BINARY_INSANE_SKIP_${PN} ?= "already-stripped"
BINARY_COMPATIBLE_MACHINE ?= "${@d.getVar('MACHINE').replace('_', '-')}"
INSANE_SKIP ??= ""

# Naming definition for files/folder to unpack.
BINARY_RECIPE_NAME ?= "${PN}_${BIN_PKGKV}.bb"
BINARY_RECIPE_PATH ?= "${THISDIR}/${BINARY_RECIPE_NAME}"
#BINARY_RECIPE_PATH_REL = "${@d.getVar('BINARY_RECIPE_PATH')[len(d.getVar('RECIPE_LAYERDIR')):]}"
BINARY_RECIPE_PATH_REL = "${@os.path.relpath(d.expand('${BINARY_RECIPE_PATH}'), d.expand('${RECIPE_LAYERDIR}'))}"

# Source definitions to pack; TODO crosssdk etc.
PACK_SOURCE ?= "${PKGDEST}"
PACK_SOURCE_class-native ?= "${PKGDEST}${STAGING_DIR_NATIVE}"
PACK_SOURCE_class-nativesdk ?= "${PKGDEST}${base_prefix}"
BIN_WORKDIR ?= "${WORKDIR}/bin-package"
BIN_WORKDIR_EXCLUDED ?= "${WORKDIR}/bin-package-excluded"

PACK_IMAGE_EXCLUDED ??= ".*-dbg"

def get_binary_for_package(pkg, d):
    #TODO more sofisticated path guessing
    source_map = {
        "package_rpm" : "${PKGWRITEDIRRPM}/${PACKAGE_ARCH_EXTEND}/${PKG}-${PKGV}-${PKGR}.${PACKAGE_ARCH_EXTEND}.rpm",
        "package_ipk" : "${PKGWRITEDIRIPK}/${PACKAGE_ARCH}/${PKG}_${PKGV}-${PKGR}_${PACKAGE_ARCH}.ipk"
    }
    # from RPM class
    package_arch = (d.getVar('PACKAGE_ARCH', True) or "").replace("-", "_")
    sdkpkgsuffix = (d.getVar('SDKPKGSUFFIX', True) or "nativesdk").replace("-", "_")
    if package_arch not in "all any noarch".split() and not package_arch.endswith(sdkpkgsuffix):
        ml_prefix = (d.getVar('MLPREFIX', True) or "").replace("-", "_")
        d.setVar('PACKAGE_ARCH_EXTEND', ml_prefix + package_arch)
    else:
        d.setVar('PACKAGE_ARCH_EXTEND', package_arch)

    preferred_package_class = d.getVar('PACKAGE_CLASSES').split()[0]

    localdata = bb.data.createCopy(d)

    overrides = localdata.getVar('OVERRIDES', False)
    localdata.setVar('OVERRIDES', '%s:%s' % (overrides, pkg))
    localdata.setVar('PKG', pkg)
    bb.data.update_data(localdata)

    return localdata.expand(source_map[preferred_package_class])

def copy_binaries(packages, to, linkdir, d):
    import shutil
    copied_packages = []
    #derived from package_tar
    for pkg in packages:
        tarfn = get_binary_for_package(pkg, d)
        bn = os.path.basename(tarfn)
        if os.path.exists(tarfn):
            shutil.copyfile(tarfn, os.path.join(to, bn))
            os.symlink(os.path.join(to, bn), os.path.join(linkdir, bn))
            copied_packages.append(pkg)
    return copied_packages

python do_pack_binary_archive() {
    bb.build.exec_func("read_subpackage_metadata", d)
    bb.build.exec_func("pack_binary_archive", d)
}
python pack_binary_archive() {
    import re, os
    if (d.getVar('BIN_ARCHIVE_ENABLED') or "1") == "0":
        return
    excluded = None
    try:
        excluded = re.compile(d.getVar('PACK_IMAGE_EXCLUDED'))
    except:
        bb.error("%s: illegal exclude pattern '%s' to package archive" %(d.getVar('PN', True), d.getVar('PACK_IMAGE_EXCLUDED', True)))
        return 
                
    packages = set(d.getVar('PACKAGES', True).split())
    if not packages:
        bb.error(1, "PACKAGES not defined, nothing to package")
        return

    included_packages = set(filter(lambda p: not excluded.match(p), list(packages)))
    excluded_packages = packages - included_packages
    excluded_sources_dir = d.getVar('BIN_WORKDIR_EXCLUDED', True)
    included_sources_dir = d.getVar('BIN_WORKDIR', True)

    copied_packages = copy_binaries(included_packages, d.getVar('DL_DIR', True), included_sources_dir, d)
    copy_binaries(excluded_packages, d.getVar('DL_DIR', True), excluded_sources_dir, d)
    do_write_binary_bb(copied_packages, d)
}
do_pack_binary_archive[sstate-inputdirs] = "${BIN_WORKDIR} ${BIN_WORKDIR_EXCLUDED}"
do_pack_binary_archive[sstate-outputdirs] = "${ARCHIVE_RELEASE_DL_DIR} ${ARCHIVE_RELEASE_EXCLUDED_DL_DIR}"
do_pack_binary_archive[dirs] = "${BIN_WORKDIR} ${BIN_WORKDIR_EXCLUDED}"
do_pack_binary_archive[cleandirs] = "${BIN_WORKDIR} ${BIN_WORKDIR_EXCLUDED}"
SSTATETASKS += "do_pack_binary_archive"

python () {
    if d.getVar('PACKAGES', True) != '':
        pn = d.getVar('PN', True)
        write_map = {
            "package_rpm" : "do_package_write_rpm",
            "package_ipk" : "do_package_write_ipk",
        }
        deps = ' %s:%s %s:do_package' % (pn, write_map[d.getVar('PACKAGE_CLASSES').split()[0]], pn)
        #d.appendVarFlag('do_pack_binary_archive', 'deps', [deps])
        d.appendVarFlag('do_pack_binary_archive', 'depends', deps)
}


do_pack_binary_archive[nostamp] = "1"

addtask pack_binary_archive after do_package do_packagedata before do_archive_release_downloads

def get_var_dissect(varname, d, locald, sep=' '):
    var = set((d.expand(varname) or "").split(sep))
    localvar = set((locald.expand(varname) or "").split(sep))
    return sep.join((localvar - var))


def do_write_binary_bb(packages, d):
    recipe_name = d.getVar("PN", True)
    if len(packages) == 0:
        bb.error("%s: no packages for binary recipe" % recipe_name)
    include_path = os.path.abspath(d.getVar("BINARY_RECIPE_PATH", True))
    archive_mirror = d.getVar("BIN_ARCHIVE_MIRROR", True)

    if os.path.exists(include_path):
        bb.utils.remove(include_path)

    file = open(include_path, 'w')
    file.write("# auto-generated for %s\n" % recipe_name)
    file.write("include ${PN}.inc\n")
    file.write("BIN_ARCHIVE_MIRROR ??= \"%s\"\n\n" % archive_mirror)
    file.write("SRC_URI += \"\\\n")
    for pkg in packages:
        bin = get_binary_for_package(pkg, d)
        basename = os.path.basename(bin)
        file.write("$%s%s;subdir=bin;md5sum=%s;sha256=%s \\\n" % ("{BIN_ARCHIVE_MIRROR}", basename, bb.utils.md5_file(bin), bb.utils.sha256_file(bin)))
    file.write("\"\n")
    file.write("S = \"${WORKDIR}/bin\"\n")
    file.write("inherit bin_package\n")
    
    file.write("DEFAULT_PREFERENCE_%s = \"%i\"\n" % (d.getVar('MACHINE', True), int(d.getVar('DEFAULT_PREFERNCE', True) or "0") + 1))
    file.write("COMPATIBLE_MACHINE = \"%s\"\n" % d.getVar('BINARY_COMPATIBLE_MACHINE', True))
    packageconfig = d.getVar('PACKAGECONFIG', True)
    bb.plain('%s PACKAGECONFIG: %s' %(recipe_name, packageconfig))
    if packageconfig != None:
        file.write("PACKAGECONFIG = \"%s\"\n" % packageconfig)

    for pkg in packages:
        localdata = bb.data.createCopy(d)

        pkgname = localdata.getVar('PKG_%s' % pkg, True)
        if not pkgname:
            pkgname = pkg
        localdata.setVar('PKG', pkgname)

        localdata.setVar('OVERRIDES', d.getVar("OVERRIDES", False) + ":" + pkg)

        bb.data.update_data(localdata)

        insane_dissect = get_var_dissect('${INSANE_SKIP} ${BINARY_INSANE_SKIP}', d, localdata)
        if insane_dissect != "":
            file.write('INSANE_SKIP_%s += "%s"\n' % (pkg.replace(localdata.getVar('PN', True), '${PN}'), insane_dissect))

    file.close()

addtask do_pack_binary_archive after do_package 
GIT_RELEASE_BRANCH_NAME ?= "release-${DATETIME}"
# HACK HACK HACK: archive release uses git tar
do_recipe_git_commit() {
    (
        cd ${RECIPE_LAYERDIR}
        current_branch="$(git branch | grep -F '*' | cut -d ' ' -f 2)"
        if [ ${current_branch} != "${GIT_RELEASE_BRANCH_NAME}" ]; then
            git checkout -b "${GIT_RELEASE_BRANCH_NAME}"
        fi
        git add "${BINARY_RECIPE_PATH_REL}"
        git commit -m "${PN}: add release ${PKGV} binary recipe"
    )
}
do_recipe_git_commit[lockfiles] += "${ARCHIVE_RELEASE_DL_TOPDIR}/${RECIPE_LAYERNAME}.lock"
addtask recipe_git_commit after do_pack_binary_archive before do_archive_release_downloads

#
# Make sure there is a license file available in the source folder.
# If this is not the case, print a warning message and copy the
# default XSe license text to the source folder.
#
