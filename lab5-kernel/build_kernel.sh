#!/usr/bin/env bash
set -euo pipefail

WORKDIR=${WORKDIR:-/work}
KERNEL_REPO=${KERNEL_REPO:-https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git}
KERNEL_TAG=${KERNEL_TAG:-v6.1}           # override in CI if needed
DEFCONFIG=${DEFCONFIG:-versatile_defconfig}  # override to e.g. am335x_evm_defconfig for BBB
TARGET_DIR="$WORKDIR/linux"
OUTDIR="$WORKDIR/artifacts/kernel"
ARCH=arm
CROSS_COMPILE=${CROSS_COMPILE:-arm-linux-gnueabihf-}

mkdir -p "$OUTDIR"
cd "$WORKDIR"

# fresh clone
rm -rf "$TARGET_DIR"
git clone --depth 1 "$KERNEL_REPO" "$TARGET_DIR"
cd "$TARGET_DIR"

if [ -n "$KERNEL_TAG" ]; then
  git fetch --tags || true
  git checkout "$KERNEL_TAG" || true
fi

echo "Cleaning..."
make ARCH=$ARCH distclean || true

echo "Configuring kernel ($DEFCONFIG)..."
make ARCH=$ARCH CROSS_COMPILE=$CROSS_COMPILE "$DEFCONFIG"

echo "Building kernel (zImage + dtbs)..."
make -j$(nproc) ARCH=$ARCH CROSS_COMPILE=$CROSS_COMPILE zImage dtbs

# copy artifacts
cp -v arch/arm/boot/zImage "$OUTDIR/" || true
mkdir -p "$OUTDIR/dts"
cp -v arch/arm/boot/dts/*.dtb "$OUTDIR/dts/" 2>/dev/null || true

echo "Kernel artifacts copied to $OUTDIR"
ls -lh "$OUTDIR" || true
