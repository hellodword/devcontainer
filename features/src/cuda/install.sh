#!/bin/bash
set -e
set +H
set -x

# https://gitlab.com/nvidia/container-images/cuda/-/tree/9dd7f6b0495ba3ab3a9424dd7124f979a2221593/dist/12.4.0/ubuntu2204

curl -fsSLO https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/${NVARCH}/cuda-keyring_1.1-1_all.deb && \
    dpkg -i cuda-keyring_1.1-1_all.deb && rm -rf cuda-keyring_1.1-1_all.deb

# For libraries in the cuda-compat-* package: https://docs.nvidia.com/cuda/eula/index.html#attachment-a
DEBIAN_FRONTEND="noninteractive" apt-get update &&
    apt-get install --no-install-recommends -y \
        cuda-cudart-12-4=${NV_CUDA_CUDART_VERSION} \
        ${NV_CUDA_COMPAT_PACKAGE} \
        cuda-libraries-12-4=${NV_CUDA_LIB_VERSION} \
        ${NV_LIBNPP_PACKAGE} \
        cuda-nvtx-12-4=${NV_NVTX_VERSION} \
        libcusparse-12-4=${NV_LIBCUSPARSE_VERSION} \
        ${NV_LIBCUBLAS_PACKAGE} \
        ${NV_LIBNCCL_PACKAGE} \
        cuda-cudart-dev-12-4=${NV_CUDA_CUDART_DEV_VERSION} \
        cuda-command-line-tools-12-4=${NV_CUDA_LIB_VERSION} \
        cuda-minimal-build-12-4=${NV_CUDA_LIB_VERSION} \
        cuda-libraries-dev-12-4=${NV_CUDA_LIB_VERSION} \
        cuda-nvml-dev-12-4=${NV_NVML_DEV_VERSION} \
        ${NV_NVPROF_DEV_PACKAGE} \
        ${NV_LIBNPP_DEV_PACKAGE} \
        libcusparse-dev-12-4=${NV_LIBCUSPARSE_DEV_VERSION} \
        ${NV_LIBCUBLAS_DEV_PACKAGE} \
        ${NV_LIBNCCL_DEV_PACKAGE} \
        ${NV_CUDA_NSIGHT_COMPUTE_DEV_PACKAGE} \
        opencl-headers ocl-icd-opencl-dev \
    && rm -rf /var/lib/apt/lists/*

# Required for nvidia-docker v1
echo "/usr/local/nvidia/lib" >> /etc/ld.so.conf.d/nvidia.conf \
    && echo "/usr/local/nvidia/lib64" >> /etc/ld.so.conf.d/nvidia.conf

# Keep apt from auto upgrading the cublas and nccl packages. See https://gitlab.com/nvidia/container-images/cuda/-/issues/88
apt-mark hold ${NV_LIBCUBLAS_PACKAGE_NAME} ${NV_LIBNCCL_PACKAGE_NAME}

# Keep apt from auto upgrading the cublas and nccl packages. See https://gitlab.com/nvidia/container-images/cuda/-/issues/88
apt-mark hold ${NV_LIBCUBLAS_DEV_PACKAGE_NAME} ${NV_LIBNCCL_DEV_PACKAGE_NAME}
