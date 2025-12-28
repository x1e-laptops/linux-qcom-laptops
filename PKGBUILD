# Maintainer: Jan Alexander Steffens (heftig) <heftig@archlinux.org>

pkgbase=linux-qcom-laptops
pkgname=(
  "$pkgbase"
)
pkgver=6.18.arch1
pkgrel=3
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
  0005-arm64-dts-qcom-support-sound-on-Asus-Vivobook-S15.patch
  0006-arm64-dts-qcom-x1e80100-asus-vivobook-s15-Enable-Iri.patch
  0007-hid-add-asus-vivobook-s-15.patch
  0011-arm64-dts-qcom-x1-asus-vivobook-s15-Add-OV02C10-RGB.patch
  0012-clk-qcom-gcc-x1e80100-Enable-runtime-PM.patch
  0013-phy-qcom-mipi-csi2-enable-runtime-PM.patch
  0014-power-supply-qcom_battmgr-clamp-charge-control-thresholds.patch
)
# https://www.kernel.org/pub/linux/kernel/v6.x/sha256sums.asc
sha256sums=('0664db35235613c7fbd5ce7c04b1b78f0e6a859c5dc520a8306e32ff5b5e2717'
            'e55878cc5c5e6e835759a61fe7b986f36c767b766abcce2cd354c07a2a4ab3e0'
            '51d945675faf0a6b46b099288f6752af50af65c713566beffb1515052542b7f4'
            'a71243dbb009b7a3a01dea57e97e5aef4e9bf759dd24e25aea25948634b27a07'
            '45c1685b55dcf51263d6c135a5194eafe42a734d7401b6c85aed88d4d19dfc24'
            '41d88df93bf6f2e7a4bb3a7d6ae430875efe04cb22599afb0f60cfee13471f21'
            'fdb08dda6360a7703041b9a40713858c10548f2b664ab538a2091c810bea7b17'
            'c1a0097e5e5640695f7d56c0dbe37d163602624b8b8c970f91221158cd321cce'
            'a2ddad95e024cde114ef248db09adb0724b469dd47950454ef74a42cdbfcad8c'
            '839727a71a35d37ec84fe85387e022d566e901c916e9f1045de779ac65ea4d28'
            '737d7967640a6a8f747243dfecb2637f6e0a7105d0b0ffe1686907d29e97947d'
            '3d5bbf875b33c84369a1e413d2303f3d77c9200678996472d75b47191bfaa2c4'
            '69067b2658b136bc440db12b4864887c2313841b1085ff4338c9ac5331a6ae67'
            'd1070adc3cc99d9b161be8399f2f8d515a83e40b12b41a61d334e04eaaeafa3b'
            '5dc4f535f4a13894c5ef9767129b04cd8c9e590b6be4cdc7b593af8faa244fa6'
            'c7fdd43c9613b10d98b0b80e8d19affd80af3cedda691524137888467747e412'
            '0923aeeeb0b6203acd97906c3edee1dee7bf9c03399bd2e7877d04951eb1e7c5')

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
