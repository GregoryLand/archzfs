# ZFSonLinux stable version (LTS packages)
AZB_ZOL_VERSION="0.6.3"

# Kernel version for GIT packages
AZB_GIT_SPL_COMMIT="03a78353"
AZB_GIT_ZFS_COMMIT="d958324f"
AZB_GIT_PKGREL="1"
AZB_GIT_KERNEL_VERSION="3.18.4"
AZB_GIT_KERNEL_X32_PKGREL="1"
AZB_GIT_KERNEL_X64_PKGREL="1"
AZB_GIT_KERNEL_X32_VERSION="${AZB_GIT_KERNEL_VERSION}-${AZB_GIT_KERNEL_X32_PKGREL}"
AZB_GIT_KERNEL_X64_VERSION="${AZB_GIT_KERNEL_VERSION}-${AZB_GIT_KERNEL_X64_PKGREL}"

# Kernel versions for LTS packages
AZB_LTS_PKGREL="1"
AZB_LTS_KERNEL_VERSION="3.14.30"
AZB_LTS_KERNEL_X32_PKGREL="1"
AZB_LTS_KERNEL_X64_PKGREL="1"
AZB_LTS_KERNEL_X32_VERSION="${AZB_LTS_KERNEL_VERSION}-${AZB_LTS_KERNEL_X32_PKGREL}"
AZB_LTS_KERNEL_X64_VERSION="${AZB_LTS_KERNEL_VERSION}-${AZB_LTS_KERNEL_X64_PKGREL}"

# Archiso Configuration
AZB_ARCHISO_PKGREL="1"
AZB_KERNEL_ARCHISO_VERSION="3.17.6"
AZB_KERNEL_ARCHISO_X32_PKGREL="1"
AZB_KERNEL_ARCHISO_X64_PKGREL="1"
AZB_KERNEL_ARCHISO_X32_VERSION="${AZB_KERNEL_ARCHISO_VERSION}-${AZB_KERNEL_ARCHISO_X32_PKGREL}"
AZB_KERNEL_ARCHISO_X64_VERSION="${AZB_KERNEL_ARCHISO_VERSION}-${AZB_KERNEL_ARCHISO_X64_PKGREL}"

# Testing repo Linux version dependencies
# AZB_KERNEL_TEST_VERSION="3.13.8"
# AZB_KERNEL_TEST_X32_PKGREL="1"
# AZB_KERNEL_TEST_X64_PKGREL="1"
# AZB_KERNEL_TEST_X32_VERSION="${AZB_KERNEL_TEST_VERSION}-${AZB_KERNEL_TEST_X32_PKGREL}"
# AZB_KERNEL_TEST_X64_VERSION="${AZB_KERNEL_TEST_VERSION}-${AZB_KERNEL_TEST_X64_PKGREL}"
# AZB_KERNEL_TEST_PKG_VERSION="${AZB_ZOL_VERSION}_${AZB_KERNEL_TEST_VERSION}"
# AZB_KERNEL_TEST_FULL_VERSION="${AZB_KERNEL_TEST_PKG_VERSION}-${AZB_GIT_PKGREL}"

# Notification address
AZB_EMAIL="jeezusjr@gmail.com"

# Repository path and name
AZB_REPO_BASEPATH="/data/pacman/repo"

# SSH login address
AZB_REMOTE_LOGIN="jalvarez@web200.webfaction.com"

# The signing key to use to sign packages
AZB_GPG_SIGN_KEY='0EE7A126'

# Package backup directory (for adding packages to demz-repo-archiso)
AZB_PACKAGE_BACKUP_DIR="/data/pacman/repo/archive_archzfs"
