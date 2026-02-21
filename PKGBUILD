# Maintainer: Jan Alexander Steffens (heftig) <heftig@archlinux.org>

pkgbase=linux-qcom-laptops
pkgname=(
  "$pkgbase"
)
pkgver=6.18.arch1
pkgrel=15
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
  config.aarch64
  misc.config
  linux-qcom-laptops.preset
  60-dtbs-remove.hook
  90-dtbs-install.hook
  dtbs.sh
  https://github.com/zig-pkgs/linux-tools/archive/refs/tags/v0.0.3.tar.gz
  https://github.com/zig-pkgs/linux-tools/releases/download/v0.0.3/linux-tools-cache-v0.0.3.tar.gz
  0001-arm64-dts-qcom-support-sound-on-Asus-Vivobook-S15.patch
  0002-arm64-dts-qcom-x1e80100-asus-vivobook-s15-Enable-Iri.patch
  0003-arm64-dts-qcom-x1-asus-vivobook-s15-Add-OV02C10-RGB-.patch
  0004-power-supply-qcom_battmgr-clamp-charge-control-thres.patch
  0005-asus-vivobook-s15-add-wip-EC-driver.patch
  0006-hid-add-asus-vivobook-s-15.patch
  0007-x1e80100-sync-changes-from-sm8750.patch
  0008-fix-compile-error-with-latest-compiler.patch
)
# https://www.kernel.org/pub/linux/kernel/v6.x/sha256sums.asc
sha256sums=('0664db35235613c7fbd5ce7c04b1b78f0e6a859c5dc520a8306e32ff5b5e2717'
            'e55878cc5c5e6e835759a61fe7b986f36c767b766abcce2cd354c07a2a4ab3e0'
            '0b12c0aaa93e4a08fe3b6697df1ac35c792057e52e0158950a3e85e40c76320a'
            '17fef7e04c66609b288d98f39f62a711fcd2414a53ad6b93fce2571314dfd249'
            '45c1685b55dcf51263d6c135a5194eafe42a734d7401b6c85aed88d4d19dfc24'
            '41d88df93bf6f2e7a4bb3a7d6ae430875efe04cb22599afb0f60cfee13471f21'
            'fdb08dda6360a7703041b9a40713858c10548f2b664ab538a2091c810bea7b17'
            'c1a0097e5e5640695f7d56c0dbe37d163602624b8b8c970f91221158cd321cce'
            'a2ddad95e024cde114ef248db09adb0724b469dd47950454ef74a42cdbfcad8c'
            '839727a71a35d37ec84fe85387e022d566e901c916e9f1045de779ac65ea4d28'
            '28cd515900418ac0587c8e104fbf94ace1169b21a02f6216626c42ce96bb2321'
            'a2af5ae1c417070df6bce7a6c6a5cfbf02e583918377a1287d54cc187110a354'
            'a7531707775b2183ee8827ae8a6c0e98f4d77fcff7d661bede70278b8771979b'
            '7c337b61c5bb1e35d5765e3617331367d5a09c61239cfa46d77b4b78aeb23fe1'
            '1faa70feba433afba0e5036532650ba1a14ddc5a5cf7a171aafb3d589f86b9ce'
            '88f9f6601671c1bb7cc792e60a977b4461b4a91960f92e6be9cc729dcb5097f3'
            '647d79bf060d8992962645848d885f3de08bf60a2b61fbbc78f3194abcf1cd61'
            '104e9e39907f5684e82f1190dfab6ea648c41deb39c57544705e91194e68884c')

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
  cp "$srcdir/config.aarch64" arch/"$ARCH"/configs/defconfig
  make defconfig qcom_laptops.config misc.config

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
