# Maintainer: Jan Alexander Steffens (heftig) <heftig@archlinux.org>

pkgbase=linux-qcom-laptops
pkgname=(
  "$pkgbase"
)
pkgver=6.18.arch1
pkgrel=6
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
  lld
)
options=(
  !debug
  !strip
)
_commit=d56d61d11040033212de5d04b580c40bcd15bb96
_srcname=linux-${_commit}
source=(
  "https://gitlab.com/Linaro/arm64-laptops/linux/-/archive/${_commit}/linux-${_commit}.tar.gz"
  https://github.com/binarycraft007/modextractor/releases/download/v0.0.2/modextractor
  kernel-aarch64-fedora.config
  misc.config
  linux-qcom-laptops.preset
  60-dtbs-remove.hook
  90-dtbs-install.hook
  dtbs.sh
  https://github.com/zig-pkgs/linux-tools/archive/refs/tags/v0.0.3.tar.gz
  https://github.com/zig-pkgs/linux-tools/releases/download/v0.0.3/linux-tools-cache-v0.0.3.tar.gz
  0001-arm64-dts-qcom-support-sound-on-Asus-Vivobook-S15.patch
  0002-arm64-dts-qcom-x1e80100-asus-vivobook-s15-Enable-Iri.patch
  0003-hid-add-asus-vivobook-s-15.patch
  0004-arm64-dts-qcom-x1-asus-vivobook-s15-Add-OV02C10-RGB-.patch
  0005-power-supply-qcom_battmgr-clamp-charge-control-thres.patch
)
# https://www.kernel.org/pub/linux/kernel/v6.x/sha256sums.asc
sha256sums=('0664db35235613c7fbd5ce7c04b1b78f0e6a859c5dc520a8306e32ff5b5e2717'
            'e55878cc5c5e6e835759a61fe7b986f36c767b766abcce2cd354c07a2a4ab3e0'
            '51d945675faf0a6b46b099288f6752af50af65c713566beffb1515052542b7f4'
            'dbfaf1572fb14384c623e4581730a0576c8f8d651a9ebe620c8b5d1687a88a20'
            '45c1685b55dcf51263d6c135a5194eafe42a734d7401b6c85aed88d4d19dfc24'
            '41d88df93bf6f2e7a4bb3a7d6ae430875efe04cb22599afb0f60cfee13471f21'
            'fdb08dda6360a7703041b9a40713858c10548f2b664ab538a2091c810bea7b17'
            'c1a0097e5e5640695f7d56c0dbe37d163602624b8b8c970f91221158cd321cce'
            'a2ddad95e024cde114ef248db09adb0724b469dd47950454ef74a42cdbfcad8c'
            '839727a71a35d37ec84fe85387e022d566e901c916e9f1045de779ac65ea4d28'
            '93c6634da87eb6eeb29eaee3dced1532c19d8b1a02bed7f8aed03198496f32b1'
            '29588b73e0b5db9a2284f8af2b2afd47bba7222bf5d1fb82861d5b1b791f59d3'
            '3967c7f0b2effc54c7cba8d62136324d5116af987814f3e3a8544507017137d9'
            'c0523ff4b413194a0ce4023a9cfc248d6eb14050243e681cf35a9a103a4fbf74'
            'bf13a62a6558a736edc9e586573565e270d7996275cbbb880ae9698d90bc2142')

export KBUILD_BUILD_HOST=archlinux
export KBUILD_BUILD_USER=$pkgbase
export KBUILD_BUILD_TIMESTAMP="$(date -Ru${SOURCE_DATE_EPOCH:+d @$SOURCE_DATE_EPOCH})"
export ARCH=arm64
export CARCH=aarch64
export MAKEFLAGS="-j$(nproc)"
export LLVM=1
export CROSS_COMPILE=aarch64-linux-gnu-

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

  unset LDFLAGS
  cp "$srcdir/misc.config" arch/"$ARCH"/configs/
  cp "$srcdir/kernel-aarch64-fedora.config" arch/"$ARCH"/configs/
  make defconfig kernel-aarch64-fedora.config qcom_laptops.config misc.config

  make -s kernelrelease > version
  echo "Prepared $pkgbase version $(<version)"
}

build() {
  cd $_srcname
  unset LDFLAGS
  make all
  make -C tools/bpf/bpftool vmlinux.h feature-clang-bpf-co-re=1
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

# vim:set ts=8 sts=2 sw=2 et:
