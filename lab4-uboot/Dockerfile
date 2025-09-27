FROM ubuntu:22.04

# Thiết lập biến môi trường để tránh nhắc nhở tương tác trong quá trình cài đặt
ENV DEBIAN_FRONTEND=noninteractive

# Cài đặt tất cả các dependencies cần thiết cho Buildroot và cho script CI của bạn
RUN apt-get update && apt-get install -y --no-install-recommends \
    # Các công cụ cơ bản cho build (build-essential, make, file, sudo)
    build-essential \
    git \
    wget \
    tar \
    cpio \
    unzip \
    sudo \
    make \
    file \
    # Cài đặt chứng chỉ và công cụ cấu hình
    ca-certificates \
    bison \
    flex \
    # Dependencies cho Buildroot
    python3 \
    python3-distutils \
    libncurses-dev \
    # Gói SSL/TLS (Khắc phục lỗi openssl/evp.h)
    # Tên gói chính xác chứa các header phát triển
    libssl-dev \
    libssl3 \
    libgnutls28-dev \
    # Công cụ cần thiết cho BeagleBone Black và ARM
    device-tree-compiler \
    u-boot-tools \
    gcc-arm-linux-gnueabihf \
    crossbuild-essential-armhf \
    qemu-system-arm \
    gdb-multiarch \

    # Dọn dẹp cache
    && rm -rf /var/lib/apt/lists/*

WORKDIR /work

CMD ["bash"]
