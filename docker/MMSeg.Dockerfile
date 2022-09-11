FROM nvcr.io/nvidia/pytorch:22.06-py3

# arg
ARG MMSEG_VERSION=0.27.0
ARG MMCV_VERSION=1.5.2
ARG BUILD_DIR="/build"

# env variables
ENV MPLCONFIGDIR /tmp
ENV TORCH_HOME /tmp
ENV MMCV_WITH_OPS 1
ENV FORCE_CUDA 1
ENV CUDA_HOME /usr/local/cuda

# create the build dir
RUN mkdir -p ${BUILD_DIR}


RUN apt update -y && apt install -y libpng-dev libjpeg-dev libgl-dev wget && rm -rf /var/lib/apt/lists/*

#####
# install mm cv
# https://mmcv.readthedocs.io/en/latest/get_started/build.html#build-on-linux-or-macos
#####
RUN wget https://github.com/open-mmlab/mmcv/archive/refs/tags/v${MMCV_VERSION}.tar.gz -O /tmp/mmcv.tar.gz
RUN tar -xzf /tmp/mmcv.tar.gz
RUN mv ./mmcv-${MMCV_VERSION} ${BUILD_DIR}/mmcv
# install it
RUN pip install -r ${BUILD_DIR}/mmcv/requirements/optional.txt
RUN pip install -v ${BUILD_DIR}/mmcv


# install mm segmentation
RUN wget https://github.com/open-mmlab/mmsegmentation/archive/refs/tags/v${MMSEG_VERSION}.tar.gz -O /tmp/mmseg.tar.gz
RUN tar -xzf /tmp/mmseg.tar.gz
RUN mv ./mmsegmentation-${MMSEG_VERSION} ${BUILD_DIR}/mmseg
# install it
RUN pip install ${BUILD_DIR}/mmseg


# set entrypint
WORKDIR /workspace
# move the mmdetection code
RUN mv ${BUILD_DIR}/mmseg /workspace/mmsegmentation
# remove the build dir
RUN rm -rf ${BUILD_DIR}

# set the entrypoint
ENTRYPOINT [ "/bin/bash" ]

