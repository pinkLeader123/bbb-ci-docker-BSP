#!/usr/bin/env bash
set -euo pipefail

WORKDIR=${WORKDIR:-/work}
BUILDROOT_TAG=${BUILDROOT_TAG:-2024.02.1}
BR_DIR="$WORKDIR/buildroot"
BOARD_DEFCONFIG=${BOARD_DEFCONFIG:-beaglebone_defconfig}
OUTDIR="$WORKDIR/artifacts/rootfs"

mkdir -p "$OUTDIR"
cd "$WORKDIR"

# clone buildroot (shallow)
rm -rf "$BR_DIR"
git clone --depth 1 https://git.buildroot.net/buildroot "$BR_DIR"
cd "$BR_DIR"

# checkout tag if set (optional)
if [ -n "$BUILDROOT_TAG" ]; then
  git fetch --tags || true
  # try checkout tag if exists
  git checkout "$BUILDROOT_TAG" 2>/dev/null || true
fi

# select defconfig
make "$BOARD_DEFCONFIG"

# ensure Buildroot will generate ext4 image (CI-friendly)
# if the .config lacks BR2_TARGET_ROOTFS_EXT4, enable it
if ! grep -q '^BR2_TARGET_ROOTFS_EXT4=y' .config 2>/dev/null; then
  echo "Enabling BR2_TARGET_ROOTFS_EXT4 in .config for CI-friendly ext4 output"
  echo "BR2_TARGET_ROOTFS_EXT4=y" >> .config
  make olddefconfig || true
fi

echo "Start Buildroot build (this may take several minutes)..."
make -j$(nproc)

# Copy rootfs.ext4 if Buildroot generated it
if [ -f output/images/rootfs.ext4 ]; then
  cp -v output/images/rootfs.ext4 "$OUTDIR/rootfs.ext4"
  echo "Buildroot produced rootfs.ext4 -> $OUTDIR/rootfs.ext4"
  ls -lh "$OUTDIR/rootfs.ext4"
  exit 0
fi

# Fallback: fail CI with informative message (avoid privileged mounts in hosted runner)
echo "ERROR: Buildroot did not produce rootfs.ext4. Please enable BR2_TARGET_ROOTFS_EXT4 in defconfig."
echo "Look at $BR_DIR/output/images/ for available images:"
ls -lah output/images || true
exit 2
