#!/usr/bin/env bash
#
# Standalone script to manage DTBs in /boot, called by alpm hooks.
#

set -e

# This function handles the installation or upgrade of DTBs.
# It is meant to be called PostTransaction.
do_install() {
    while read -r line; do
        # We only care about the vmlinuz file path provided by the hook trigger
        if [[ "$line" != */vmlinuz ]]; then
            continue
        fi

        local kmod_dir="${line%/vmlinuz}"
        local pkgbase

        # Read the pkgbase from the file included in the kernel package
        if ! read -r pkgbase <"${kmod_dir}/pkgbase"; then
            echo "Warning: could not determine pkgbase for kernel in ${kmod_dir}. Skipping DTB installation."
            continue
        fi

        local dtb_src_dir="${kmod_dir}/dtbs"
        #local dtb_tgt_dir="/boot/dtbs/${pkgbase}"
        local dtb_tgt_dir="/boot/dtbs"

        # Check if the kernel package provides a dtbs directory
        if [[ -d "$dtb_src_dir" ]]; then
            echo ":: Installing DTBs for ${pkgbase} to ${dtb_tgt_dir}"
            install -d "${dtb_tgt_dir}"
            # Copy the contents of the source directory to the target
            cp -a -- "${dtb_src_dir}/." "${dtb_tgt_dir}/"
        fi
    done
}

# This function handles the removal of DTBs.
# It is meant to be called PreTransaction, while the /usr/lib/modules files still exist.
do_remove() {
    while read -r line; do
        # We only care about the vmlinuz file path
        if [[ "$line" != */vmlinuz ]]; then
            continue
        fi

        local kmod_dir="${line%/vmlinuz}"
        local pkgbase

        # Read pkgbase to determine which directory in /boot/dtbs to remove
        if ! read -r pkgbase <"${kmod_dir}/pkgbase"; then
            echo "Warning: could not determine pkgbase for kernel in ${kmod_dir}. Skipping DTB removal."
            continue
        fi

        #local dtb_tgt_dir="/boot/dtbs/${pkgbase}"
        local dtb_tgt_dir="/boot/dtbs"

        if [[ -d "$dtb_tgt_dir" ]]; then
            echo ":: Removing DTBs for ${pkgbase} from ${dtb_tgt_dir}"
            rm -rf -- "${dtb_tgt_dir}"
        fi
    done
}

# Main script logic: decide which function to run based on the first argument.
case "$1" in
    install)
        do_install
        ;;
    remove)
        do_remove
        ;;
    *)
        echo "Usage: $0 [install|remove]"
        exit 1
        ;;
esac
