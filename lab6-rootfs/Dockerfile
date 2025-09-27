FROM ubuntu:22.04
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential git cpio rsync \
    python3 python3-distutils \
    bc bison flex libncurses-dev \
    wget xz-utils unzip \
    device-tree-compiler u-boot-tools \
    qemu-utils \
    e2fsprogs genext2fs dosfstools parted curl \
    gcc-arm-linux-gnueabihf crossbuild-essential-armhf \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*
WORKDIR /work
CMD ["bash"]
