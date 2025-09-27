#!/usr/bin/env bash
set -euo pipefail

WORKDIR=${WORKDIR:-/work}
UBOOT_REPO=${UBOOT_REPO:-https://source.denx.de/u-boot/u-boot.git}
UBOOT_TAG=${UBOOT_TAG:-v2024.07}
UBOOT_DEFCONFIG=${UBOOT_DEFCONFIG:-am335x_evm_defconfig}
OUTDIR="$WORKDIR/artifacts/uboot"

echo "Workdir: $WORKDIR"
mkdir -p "$OUTDIR"
cd "$WORKDIR"

# fresh clone
rm -rf u-boot
git clone --depth 1 "$UBOOT_REPO" u-boot
cd u-boot

# checkout tag/branch if specified
if [ -n "$UBOOT_TAG" ]; then
  git fetch --tags || true
  git checkout "$UBOOT_TAG" || true
fi

echo "Cleaning..."
make distclean || true

export CROSS_COMPILE=arm-linux-gnueabihf-
export ARCH=arm

echo "Configuring ($UBOOT_DEFCONFIG) ..."
make "${UBOOT_DEFCONFIG}"

echo "Building U-Boot..."
make -j$(nproc)

# copy likely artifacts to OUTDIR (tolerant: copy if exist)
cp -v MLO u-boot.img u-boot.bin u-boot* 2>/dev/null || true
# copy everything built in repo root that looks like u-boot
for f in MLO u-boot.img u-boot.bin u-boot; do
  [ -f "$f" ] && cp -av "$f" "$OUTDIR/"
done

# also copy the whole tree (optional small)
cp -av u-boot* "$OUTDIR/" 2>/dev/null || true

echo "U-Boot artifacts in: $OUTDIR"
ls -lh "$OUTDIR" || true
