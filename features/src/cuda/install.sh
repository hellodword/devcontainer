#!/bin/bash
set -e
set +H
set -x

# https://gitlab.com/nvidia/container-images/cuda/-/tree/9dd7f6b0495ba3ab3a9424dd7124f979a2221593/dist/12.4.0/ubuntu2204

curl -fsSLO https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/${NVARCH}/cuda-keyring_1.1-1_all.deb && \
    sudo dpkg -i cuda-keyring_1.1-1_all.deb && rm -rf cuda-keyring_1.1-1_all.deb

sudo apt-get update && \
    DEBIAN_FRONTEND="noninteractive" sudo apt-get install -y software-properties-common python3-launchpadlib && \
    sudo add-apt-repository -y ppa:ocl-icd/ppa

# for pocl
export LLVM_VERSION=14
_CUDA_VERSION_PREFIX=$(echo "${CUDA_VERSION}" | awk -F. '{print $1 "-" $2}')
# For libraries in the cuda-compat-* package: https://docs.nvidia.com/cuda/eula/index.html#attachment-a
sudo apt-get update &&
    DEBIAN_FRONTEND="noninteractive" sudo apt-get install --no-install-recommends -y \
        cuda-cudart-${_CUDA_VERSION_PREFIX}=${NV_CUDA_CUDART_VERSION} \
        ${NV_CUDA_COMPAT_PACKAGE} \
        cuda-libraries-${_CUDA_VERSION_PREFIX}=${NV_CUDA_LIB_VERSION} \
        ${NV_LIBNPP_PACKAGE} \
        cuda-nvtx-${_CUDA_VERSION_PREFIX}=${NV_NVTX_VERSION} \
        libcusparse-${_CUDA_VERSION_PREFIX}=${NV_LIBCUSPARSE_VERSION} \
        ${NV_LIBCUBLAS_PACKAGE} \
        ${NV_LIBNCCL_PACKAGE} \
        cuda-cudart-dev-${_CUDA_VERSION_PREFIX}=${NV_CUDA_CUDART_DEV_VERSION} \
        cuda-command-line-tools-${_CUDA_VERSION_PREFIX}=${NV_CUDA_LIB_VERSION} \
        cuda-minimal-build-${_CUDA_VERSION_PREFIX}=${NV_CUDA_LIB_VERSION} \
        cuda-libraries-dev-${_CUDA_VERSION_PREFIX}=${NV_CUDA_LIB_VERSION} \
        cuda-nvml-dev-${_CUDA_VERSION_PREFIX}=${NV_NVML_DEV_VERSION} \
        ${NV_NVPROF_DEV_PACKAGE} \
        ${NV_LIBNPP_DEV_PACKAGE} \
        libcusparse-dev-${_CUDA_VERSION_PREFIX}=${NV_LIBCUSPARSE_DEV_VERSION} \
        ${NV_LIBCUBLAS_DEV_PACKAGE} \
        ${NV_LIBNCCL_DEV_PACKAGE} \
        ${NV_CUDA_NSIGHT_COMPUTE_DEV_PACKAGE} \
        opencl-headers clinfo \
        ocl-icd-libopencl1 ocl-icd-opencl-dev ocl-icd-dev \
        python3-dev libpython3-dev build-essential ocl-icd-libopencl1 \
        cmake git pkg-config libclang-${LLVM_VERSION}-dev clang-${LLVM_VERSION} \
        llvm-${LLVM_VERSION} make ninja-build ocl-icd-libopencl1 ocl-icd-dev \
        ocl-icd-opencl-dev libhwloc-dev zlib1g zlib1g-dev clinfo dialog apt-utils \
        libxml2-dev libclang-cpp${LLVM_VERSION}-dev libclang-cpp${LLVM_VERSION} \
        llvm-${LLVM_VERSION}-dev

# Required for nvidia-docker v1
echo "/usr/local/nvidia/lib" | sudo tee -a /etc/ld.so.conf.d/nvidia.conf \
    && echo "/usr/local/nvidia/lib64" | sudo tee -a /etc/ld.so.conf.d/nvidia.conf

# Keep apt from auto upgrading the cublas and nccl packages. See https://gitlab.com/nvidia/container-images/cuda/-/issues/88
sudo apt-mark hold ${NV_LIBCUBLAS_PACKAGE_NAME} ${NV_LIBNCCL_PACKAGE_NAME}

# Keep apt from auto upgrading the cublas and nccl packages. See https://gitlab.com/nvidia/container-images/cuda/-/issues/88
sudo apt-mark hold ${NV_LIBCUBLAS_DEV_PACKAGE_NAME} ${NV_LIBNCCL_DEV_PACKAGE_NAME}

# for docker
sudo mkdir -p /etc/OpenCL/vendors && \
    echo "libnvidia-opencl.so.1" | sudo tee /etc/OpenCL/vendors/nvidia.icd

# install the latest pocl
pushd /tmp
# avoid using github api which has rate limit, especially with VPN
REPO="pocl/pocl"
LATEST_VERSION="$(curl -fsS -w "%{redirect_url}" -o /dev/null "https://github.com/$REPO/releases/latest" | grep -oP '(?<=/releases/tag/)[^/]+$')"
[ -n "$LATEST_VERSION" ]
git clone -b "$LATEST_VERSION" --depth=1 --recurse-submodules https://github.com/pocl/pocl
cd pocl
mkdir build
cd build
cmake ..
make
sudo make install
sudo cp pocl.icd /etc/OpenCL/vendors/pocl.icd
popd
rm -rf /tmp/pocl


DEBIAN_FRONTEND="noninteractive" sudo apt-get install --no-install-recommends -y \
    g++ cmake ninja-build \
    llvm-15-dev libz-dev libglew-dev \
    flex bison libfl-dev libboost-thread-dev libboost-filesystem-dev nvidia-cuda-toolkit-gcc libzstd-dev
sudo apt-get clean