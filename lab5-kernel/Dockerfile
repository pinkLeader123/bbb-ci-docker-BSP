FROM ubuntu:22.04
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential bc bison flex libssl-dev libncurses-dev \
    device-tree-compiler u-boot-tools wget xz-utils cpio rsync \
    gcc-arm-linux-gnueabihf crossbuild-essential-armhf \
    git python3 python3-distutils \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*
WORKDIR /work
CMD ["bash"]
