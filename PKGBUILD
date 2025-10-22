# Maintainer: Jan Alexander Steffens (heftig) <heftig@archlinux.org>

pkgbase=linux-qcom-laptops
pkgname=(
  "$pkgbase"
  "$pkgbase-headers"
)
pkgver=6.18.rc3.arch1
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
_commit=093ac7a592c6e247f255528330e970be957014ac
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
  0015-Revert-PCI-qcom-Remove-custom-ASPM-enablement-code.patch
  0016-dts-add-ramoops-reserved-mem.patch
)
# https://www.kernel.org/pub/linux/kernel/v6.x/sha256sums.asc
sha256sums=('b917e2ba482e4913094e24bbd555666ecb39734110b0f174ebe336454053d563'
            'e55878cc5c5e6e835759a61fe7b986f36c767b766abcce2cd354c07a2a4ab3e0'
            '5238a2ad32e247dce6f58a4d030d6061aa3b2fb07059165724c67ee4007b1171'
            'a71243dbb009b7a3a01dea57e97e5aef4e9bf759dd24e25aea25948634b27a07'
            '45c1685b55dcf51263d6c135a5194eafe42a734d7401b6c85aed88d4d19dfc24'
            '41d88df93bf6f2e7a4bb3a7d6ae430875efe04cb22599afb0f60cfee13471f21'
            'fdb08dda6360a7703041b9a40713858c10548f2b664ab538a2091c810bea7b17'
            'c1a0097e5e5640695f7d56c0dbe37d163602624b8b8c970f91221158cd321cce'
            'a2ddad95e024cde114ef248db09adb0724b469dd47950454ef74a42cdbfcad8c'
            '839727a71a35d37ec84fe85387e022d566e901c916e9f1045de779ac65ea4d28'
            '737d7967640a6a8f747243dfecb2637f6e0a7105d0b0ffe1686907d29e97947d'
            '3d5bbf875b33c84369a1e413d2303f3d77c9200678996472d75b47191bfaa2c4'
            'c26c2aac1ed57a11df77fcf1205dc483fb6001176000d09d09b48cd3686e765e'
            'd1070adc3cc99d9b161be8399f2f8d515a83e40b12b41a61d334e04eaaeafa3b'
            '5dc4f535f4a13894c5ef9767129b04cd8c9e590b6be4cdc7b593af8faa244fa6'
            'c7fdd43c9613b10d98b0b80e8d19affd80af3cedda691524137888467747e412'
            '0923aeeeb0b6203acd97906c3edee1dee7bf9c03399bd2e7877d04951eb1e7c5'
            '3cbdc35fd891cd1fc27d0d3730d0427f66b5685245d6d9ca96588e3abd602310'
            'f7c4eab43a06cbdacc830ecc80d4077d865a486c9b5d98996c6014878fb7ab4a')

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

  cp "$srcdir"/linux-tools-0.0.3/build.zig* ./
  zig build -Dtarget=aarch64-linux -Doptimize=ReleaseSmall \
    --global-cache-dir "$srcdir"/linux-tools-cache-v0.0.3 \
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
