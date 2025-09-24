# Maintainer: Jan Alexander Steffens (heftig) <heftig@archlinux.org>

pkgbase=linux-qcom-laptops
pkgname=(
  "$pkgbase"
  "$pkgbase-headers"
)
pkgver=6.17.rc5.arch1
pkgrel=8
pkgdesc='Linux for qcom laptops'
url='https://gitlab.com/Linaro/arm64-laptops/linux'
arch=('x86_64' 'aarch64')
license=(GPL-2.0-only)
makedepends=(
  bc
  cpio
  gettext
  libelf
  pahole
  perl
  python
  tar
  xz
  kmod
  zig
  clang
  llvm
)
options=(
  !debug
  !strip
)
_branch=qcom-laptops
_base_pkgver=${pkgver%.arch*}
_srctag=v${_base_pkgver%.*}-${_base_pkgver##*.}
_srcname=$pkgbase-${_srctag}
source=(
  https://gitlab.com/Linaro/arm64-laptops/linux/-/archive/qcom-laptops-v6.17-rc5/linux-qcom-laptops-v6.17-rc5.tar.gz
  https://github.com/binarycraft007/modextractor/releases/download/v0.0.1/modextractor
  pmos.config
  misc.config
  linux-qcom-laptops.preset
  60-dtbs-remove.hook
  90-dtbs-install.hook
  dtbs.sh
  https://github.com/zig-pkgs/linux-tools/archive/refs/tags/v0.0.1.tar.gz
  https://github.com/zig-pkgs/linux-tools/releases/download/v0.0.1/linux-tools-cache-v0.0.1.tar.gz
  0001-arm64-dts-qcom-Add-support-for-Dell-Inspiron-7441-La.patch
  0002-arm64-dts-qcom-x1e80100-dell-inspiron14-7441-Switch-.patch
  0003-media-ov02c10-Fix-default-vertical-flip.patch
  0004-media-ov02c10-Support-hflip-and-vflip.patch
  0005-arm64-dts-qcom-x1e80100-t14s-Mark-ov02c10-as-inverte.patch
  0006-media-ov02c10-Invert-bayer-order-when-rotation-is-pr.patch
  0007-arm64-dts-qcom-x1e80100-Add-videocc.patch
  0008-dt-bindings-media-qcom-sm8550-iris-Add-X1E80100-comp.patch
  0009-arm64-dts-qcom-x1e80100-Add-IRIS-video-codec.patch
  0010-arm64-dts-qcom-x1e80100-crd-Enable-IRIS-video-codec.patch
  0011-arm64-dts-qcom-support-sound-on-Asus-Vivobook-S15.patch
  0012-arm64-dts-qcom-x1e80100-asus-vivobook-s15-Enable-Iri.patch
  0013-hid-add-asus-vivobook-s-15.patch
  0014-PCI-ASPM-Allow-controller-drivers-to-override-defaul.patch
)
# https://www.kernel.org/pub/linux/kernel/v6.x/sha256sums.asc
sha256sums=(
  'd565a50f6c14d366d812b36b01ee2e60b367f2e8ef6e6e9b92cf465488cf591b'
  '5ce56beb80c1e49a9cba4148144bd22ee5f37d8d02a3c0cea97d3766a9b1460f'
  '72197885465d3f07b9d5ea7b11fb720f15070b7eeb57b73c0a83082c290bee00'
  '4f706de5a92c30d614a4cd5cf9351cafce28fd8ef83b56fcc6820973fcce2421'
  '45c1685b55dcf51263d6c135a5194eafe42a734d7401b6c85aed88d4d19dfc24'
  '41d88df93bf6f2e7a4bb3a7d6ae430875efe04cb22599afb0f60cfee13471f21'
  'fdb08dda6360a7703041b9a40713858c10548f2b664ab538a2091c810bea7b17'
  'c1a0097e5e5640695f7d56c0dbe37d163602624b8b8c970f91221158cd321cce'
  'a05cbef6253c21ba96cf03d97fe9df69acf5625d58b5034ddaf0183ab8e0fff7'
  '10deee7fd409cd463bee7e5b53e5e78a2ad64959734b6e43559fa870e405376b'
  '9587fdd823c3a4344a535ff79a61502910175f8c6358b3714b3a4987464b1386'
  'abbbba03332c35496f000998b8f1c84bb681abdfdf60a84703ae929e8a337623'
  'e046ff03b962eeb260640cb0513c270ec8ace8a3a458492599a2d5ba045d6a9f'
  'ba16a3ee5c1d0ab3eebc1f1d86adb631ec511be7a1f1b00c7f2f69a289d0d524'
  '11875bcf2f3a699c4f198e1db67d93ebf3f19c3ddd6ca12312c0e418ea34bbab'
  '1967472090ad1eae294d1da242c0485b3f105f773ab35aff2c2f18a15b0cc945'
  'c1666b7cd8cbb3d6ab20ccd30e8bf43a500a23a6a28949ccb4c14cb2d7d67b85'
  '3a35f1c67ad73c26bd2fa7a3f674f06c1a80f6d6d16c11f7e09aa22eee4cd815'
  '40b5f65beaa23f8e22b01b309fc4ffcc12914e8f3baf5983f5fc382e5167b05f'
  'f857615dedf69082825090b8cecdb5a6277b75be21fc5493e04ba3eaed9f21e5'
  '19bf0c9a4489a550472d325fb61493b732028f767121013667cfa9b733306bce'
  'f2f000d6f7d071c4dc55f341b5a0c3835377764ed560cd099d8b714509628742'
  'cd0e029b2a8eae3dec616b2eb869ac21c72197ec6c5658a808024dbb8617ff47'
  '4bb05d46c6b699e85ff9708b9f3303d463ada1527ee34ae0846eed826d02436f'
)

export KBUILD_BUILD_HOST=archlinux
export KBUILD_BUILD_USER=$pkgbase
export KBUILD_BUILD_TIMESTAMP="$(date -Ru${SOURCE_DATE_EPOCH:+d @$SOURCE_DATE_EPOCH})"
export ARCH=arm64
export CARCH=aarch64
export MAKEFLAGS="-j$(nproc)"

prepare() {
  cd $_srcname

  chmod +x ../modextractor

  echo "Setting version..."
  echo "-$pkgrel" > localversion.10-pkgrel
  echo "${pkgbase#linux}" > localversion.20-pkgname

  local src
  for src in "${source[@]}"; do
    src="${src%%::*}"
    src="${src##*/}"
    src="${src%.zst}"
    [[ $src = *.patch ]] || continue
    echo "Applying patch $src..."
    patch -Np1 < "../$src"
  done

  echo "Setting config..."

  cp "$srcdir/pmos.config" arch/"$ARCH"/configs/
  cp "$srcdir/misc.config" arch/"$ARCH"/configs/
  make LLVM=1 defconfig qcom_laptops.config pmos.config misc.config

  make LLVM=1 -s kernelrelease > version
  echo "Prepared $pkgbase version $(<version)"
}

build() {
  cd $_srcname
  make LLVM=1 all
  make LLVM=1 -C tools/bpf/bpftool vmlinux.h feature-clang-bpf-co-re=1
}

package_linux-qcom-laptops() {
  pkgdesc+=" - Kernel and modules"
  depends=(
    coreutils
    initramfs
    kmod
  )
  optdepends=(
    'linux-firmware: firmware images needed for some devices'
    'scx-scheds: to use sched-ext schedulers'
    'wireless-regdb: to set the correct wireless channels of your country'
  )
  provides=(
    KSMBD-MODULE
    NTSYNC-MODULE
    VIRTUALBOX-GUEST-MODULES
    WIREGUARD-MODULE
  )
  replaces=(
    virtualbox-guest-modules-arch
    wireguard-arch
  )

  cd $_srcname
  local modulesdir="$pkgdir/usr/lib/modules/$(<version)"

  echo "Installing boot image..."
  # systemd expects to find the kernel here to allow hibernation
  # https://github.com/systemd/systemd/commit/edda44605f06a41fb86b7ab8128dcf99161d2344
  install -Dm644 "$(make -s image_name)" "$modulesdir/vmlinuz"

  # Used by mkinitcpio to name the kernel
  echo "$pkgbase" | install -Dm644 /dev/stdin "$modulesdir/pkgbase"

  echo "Installing modules and dtbs..."
  ZSTD_CLEVEL=19 make modules_install dtbs_install \
    INSTALL_MOD_PATH="$pkgdir"/usr \
    INSTALL_MOD_STRIP=1 \
    DEPMOD=/doesnt/exist \
    INSTALL_DTBS_PATH="$modulesdir"/dtbs

  depmod -b "$pkgdir"/usr $(basename $modulesdir)

  "$srcdir"/modextractor $modulesdir $modulesdir/dtbs/qcom/x1e80100-asus-vivobook-s15.dtb |
    install -Dm644 /dev/stdin "${pkgdir}/etc/mkinitcpio.conf.d/$pkgbase.conf"

  install -Dm755 "$srcdir"/dtbs.sh "${pkgdir}/usr/share/libalpm/scripts/dtbs"
  install -Dm644 "$srcdir"/60-dtbs-remove.hook \
    "${pkgdir}/usr/share/libalpm/hooks/60-dtbs-remove.hook"
  install -Dm644 "$srcdir"/90-dtbs-install.hook \
    "${pkgdir}/usr/share/libalpm/hooks/90-dtbs-install.hook"

  # remove build link
  rm "$modulesdir"/build
}

package_linux-qcom-laptops-headers() {
  pkgdesc+=" - Headers and scripts"
  depends=(pahole)

  cd $_srcname
  local builddir="$pkgdir/usr/lib/modules/$(<version)/build"

  echo "Installing build files..."
  install -Dt "$builddir" -m644 .config Makefile Module.symvers System.map \
    localversion.* version vmlinux tools/bpf/bpftool/vmlinux.h
  install -Dt "$builddir/kernel" -m644 kernel/Makefile
  install -Dt "$builddir/arch/$ARCH" -m644 arch/$ARCH/Makefile
  cp -t "$builddir" -a scripts
  ln -srt "$builddir" "$builddir/scripts/gdb/vmlinux-gdb.py"

  echo "Installing headers..."
  cp -t "$builddir" -a include
  cp -t "$builddir/arch/$ARCH" -a arch/$ARCH/include
  install -Dt "$builddir/arch/$ARCH/kernel" -m644 arch/$ARCH/kernel/asm-offsets.s

  install -Dt "$builddir/drivers/md" -m644 drivers/md/*.h
  install -Dt "$builddir/net/mac80211" -m644 net/mac80211/*.h

  # https://bugs.archlinux.org/task/13146
  install -Dt "$builddir/drivers/media/i2c" -m644 drivers/media/i2c/msp3400-driver.h

  # https://bugs.archlinux.org/task/20402
  install -Dt "$builddir/drivers/media/usb/dvb-usb" -m644 drivers/media/usb/dvb-usb/*.h
  install -Dt "$builddir/drivers/media/dvb-frontends" -m644 drivers/media/dvb-frontends/*.h
  install -Dt "$builddir/drivers/media/tuners" -m644 drivers/media/tuners/*.h

  # https://bugs.archlinux.org/task/71392
  install -Dt "$builddir/drivers/iio/common/hid-sensors" -m644 drivers/iio/common/hid-sensors/*.h

  echo "Installing KConfig files..."
  find . -name 'Kconfig*' -exec install -Dm644 {} "$builddir/{}" \;

  echo "Installing unstripped VDSO..."
  make INSTALL_MOD_PATH="$pkgdir/usr" vdso_install \
    link=  # Suppress build-id symlinks

  cp "$srcdir"/linux-tools-0.0.1/build.zig* ./
  zig build -Dtarget=aarch64-linux -Doptimize=ReleaseSmall \
    --global-cache-dir "$srcdir"/linux-tools-cache-v0.0.1 \
    -p "$builddir" --summary all
  rm build.zig*

  echo "Removing unneeded architectures..."
  local arch
  for arch in "$builddir"/arch/*/; do
    [[ $arch = */$ARCH/ ]] && continue
    echo "Removing $(basename "$arch")"
    rm -r "$arch"
  done

  echo "Removing documentation..."
  rm -r "$builddir/Documentation"

  echo "Removing broken symlinks..."
  find -L "$builddir" -type l -printf 'Removing %P\n' -delete

  echo "Removing loose objects..."
  find "$builddir" -type f -name '*.o' -printf 'Removing %P\n' -delete

  echo "Stripping vmlinux..."
  strip -v $STRIP_STATIC "$builddir/vmlinux"

  echo "Adding symlink..."
  mkdir -p "$pkgdir/usr/src"
  ln -sr "$builddir" "$pkgdir/usr/src/$pkgbase"
}

# vim:set ts=8 sts=2 sw=2 et:
