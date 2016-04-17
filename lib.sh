shopt -s nullglob


unset ALL_OFF BOLD BLUE GREEN RED YELLOW WHITE

# prefer terminal safe colored and bold text when tput is supported
ALL_OFF="$(tput sgr0 2> /dev/null)"
BOLD="$(tput bold 2> /dev/null)"
BLUE="${BOLD}$(tput setaf 4 2> /dev/null)"
GREEN="${BOLD}$(tput setaf 2 2> /dev/null)"
RED="${BOLD}$(tput setaf 1 2> /dev/null)"
YELLOW="${BOLD}$(tput setaf 3 2> /dev/null)"
WHITE="${BOLD}$(tput setaf 7 2> /dev/null)"
readonly ALL_OFF BOLD BLUE GREEN RED YELLOW

plain() {
    local mesg=$1; shift
    printf "${WHITE}     ○ ${ALL_OFF}${BOLD}${mesg}${ALL_OFF}\n" "$@"
}

msg() {
    local mesg=$1; shift
    printf "${GREEN}==== ${ALL_OFF}${WHITE}${BOLD} ${mesg}${ALL_OFF}\n" "$@"
}

msg2() {
    local mesg=$1; shift
    printf "${BLUE}++++  ${ALL_OFF}${WHITE}${BOLD}${mesg}${ALL_OFF}\n" "$@"
}

warning() {
    local mesg=$1; shift
    printf "${YELLOW}====  WARNING: ${ALL_OFF}${WHITE}${BOLD} ${mesg}${ALL_OFF}\n" "$@"
}

error() {
    local mesg=$1; shift
    printf "${RED}====  ERROR: ${ALL_OFF}${BOLD}${WHITE}${mesg}${ALL_OFF}\n" "$@" >&2
}

send_email() {
    # $1 = Message
    # $2 = Subject
    # $3 = attachment
    if [[ $3 == "" ]]; then
        echo -e "${1}" | mutt -s "${2}" "${AZB_EMAIL}"
    else
        echo -e "${1}" | mutt -s "${2}" "${AZB_EMAIL}" -a "${3}"
    fi
}

debug() {
    # $1: The message to print.
    if [[ $DEBUG -eq 1 ]]; then
        plain "DEBUG: $1"
    fi
}

run_cmd() {
    # $1: The command to run
    if [[ $DRY_RUN -eq 1 ]]; then
        for pos in $@; do
            plain $pos
        done
    else
        plain "Running command: $@"
        eval "$@"
        plain "Command returned: $?"
    fi
}

cleanup() {
    exit $1 || true
}

abort() {
    msg 'Aborting...'
    cleanup 0
}

trap_abort() {
    trap - EXIT INT QUIT TERM HUP
    abort
}

trap_exit() {
    trap - EXIT INT QUIT TERM HUP
    cleanup
}

die() {
    (( $# )) && error "$@"
    cleanup 1
}

package_arch_from_path() {
    # $1: Package path
    pacman -Qip "$1" | grep "Architecture" | cut -d : -f 2 | tr -d ' '
    return $?
}

package_name_from_path() {
    # $1: Package path
    pacman -Qip "$1" | grep "Name" | cut -d : -f 2 | tr -d ' '
    return $?
}

package_version_from_path() {
    # $1: Package path
    pacman -Qip "$1" | grep "Version" | cut -d : -f 2 | tr -d ' '
    return $?
}

package_version_from_syncdb() {
    # $1: Package name
    pacman -Si "$1" | grep "Version" | cut -d : -f 2 | tr -d ' '
    return $?
}

full_kernel_git_version() {
    # Determine if the kernel version has the format 3.14 or 3.14.1
    if [[ ${AZB_GIT_KERNEL_VERSION} =~ ^[[:digit:]]+\.[[:digit:]]+\.([[:digit:]]+) ]]; then
        debug "full_kernel_git_version: Have kernel with minor version!"
    fi
    debug "full_kernel_git_version: BASH_REMATCH[1] == '${BASH_REMATCH[1]}'"
    if [[ ${BASH_REMATCH[1]} != "" ]]; then
        AZB_GIT_KERNEL_X32_VERSION_FULL=${AZB_GIT_KERNEL_X32_VERSION}
        AZB_GIT_KERNEL_X64_VERSION_FULL=${AZB_GIT_KERNEL_X64_VERSION}
        AZB_GIT_KERNEL_X32_VERSION_CLEAN=$(echo ${AZB_GIT_KERNEL_X32_VERSION} | sed s/-/_/g)
        AZB_GIT_KERNEL_X64_VERSION_CLEAN=$(echo ${AZB_GIT_KERNEL_X64_VERSION} | sed s/-/_/g)
    else
        debug "full_kernel_git_version: Have kernel without minor version!'"
        # Kernel version has the format 3.14, so add a 0.
        AZB_GIT_KERNEL_X32_VERSION_FULL=${AZB_GIT_KERNEL_VERSION}.0-${AZB_GIT_KERNEL_X32_PKGREL}
        AZB_GIT_KERNEL_X64_VERSION_FULL=${AZB_GIT_KERNEL_VERSION}.0-${AZB_GIT_KERNEL_X64_PKGREL}
        AZB_GIT_KERNEL_X32_VERSION_CLEAN=$(echo ${AZB_GIT_KERNEL_X32_VERSION_FULL} | sed s/-/_/g)
        AZB_GIT_KERNEL_X64_VERSION_CLEAN=$(echo ${AZB_GIT_KERNEL_X64_VERSION_FULL} | sed s/-/_/g)
    fi
}

full_kernel_lts_version() {
    # Determine if the kernel version has the format 3.14 or 3.14.1
    [[ ${AZB_LTS_KERNEL_VERSION} =~ ^[[:digit:]]+\.[[:digit:]]+\.([[:digit:]]+) ]]
    if [[ ${BASH_REMATCH[1]} != "" ]]; then
        AZB_LTS_KERNEL_X32_VERSION_FULL=${AZB_LTS_KERNEL_X32_VERSION}
        AZB_LTS_KERNEL_X64_VERSION_FULL=${AZB_LTS_KERNEL_X64_VERSION}
        AZB_LTS_KERNEL_X32_VERSION_CLEAN=$(echo ${AZB_LTS_KERNEL_X32_VERSION} | sed s/-/_/g)
        AZB_LTS_KERNEL_X64_VERSION_CLEAN=$(echo ${AZB_LTS_KERNEL_X64_VERSION} | sed s/-/_/g)
    else
        # Kernel version has the format 3.14, so add a 0.
        AZB_LTS_KERNEL_X32_VERSION_FULL=${AZB_LTS_KERNEL_VERSION}.0-${AZB_LTS_KERNEL_X32_PKGREL}
        AZB_LTS_KERNEL_X64_VERSION_FULL=${AZB_LTS_KERNEL_VERSION}.0-${AZB_LTS_KERNEL_X64_PKGREL}
        AZB_LTS_KERNEL_X32_VERSION_CLEAN=$(echo ${AZB_LTS_KERNEL_X32_VERSION_FULL} | sed s/-/_/g)
        AZB_LTS_KERNEL_X64_VERSION_CLEAN=$(echo ${AZB_LTS_KERNEL_X64_VERSION_FULL} | sed s/-/_/g)
    fi
}

full_kernel_archiso_version() {
    # Determine if the archiso kernel version has the format 3.14 or 3.14.1
    [[ ${AZB_KERNEL_ARCHISO_VERSION} =~ ^[[:digit:]]+\.[[:digit:]]+\.([[:digit:]]+) ]]
    if [[ ${BASH_REMATCH[1]} != "" ]]; then
        AZB_KERNEL_ARCHISO_X32_VERSION_FULL=${AZB_KERNEL_ARCHISO_X32_VERSION}
        AZB_KERNEL_ARCHISO_X32_VERSION_CLEAN=$(echo ${AZB_KERNEL_ARCHISO_X32_VERSION} | sed s/-/_/g)
        AZB_KERNEL_ARCHISO_X64_VERSION_FULL=${AZB_KERNEL_ARCHISO_X64_VERSION}
        AZB_KERNEL_ARCHISO_X64_VERSION_CLEAN=$(echo ${AZB_KERNEL_ARCHISO_X64_VERSION} | sed s/-/_/g)
    else
        # Kernel version has the format 3.14, so add a 0.
        AZB_KERNEL_ARCHISO_X32_VERSION_FULL=${AZB_KERNEL_ARCHISO_VERSION}.0-${AZB_KERNEL_ARCHISO_X32_PKGREL}
        AZB_KERNEL_ARCHISO_X32_VERSION_CLEAN=${AZB_KERNEL_ARCHISO_VERSION}.0_${AZB_KERNEL_ARCHISO_X32_PKGREL}
        AZB_KERNEL_ARCHISO_X64_VERSION_FULL=${AZB_KERNEL_ARCHISO_VERSION}.0-${AZB_KERNEL_ARCHISO_X64_PKGREL}
        AZB_KERNEL_ARCHISO_X64_VERSION_CLEAN=${AZB_KERNEL_ARCHISO_VERSION}.0_${AZB_KERNEL_ARCHISO_X64_PKGREL}
    fi
}
