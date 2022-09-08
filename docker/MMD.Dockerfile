FROM nvcr.io/nvidia/pytorch:22.06-py3

# arg
ARG MMDET_VERSION=2.25.0
ARG MMCV_VERSION=1.5.2
ARG MMCLS_VERSION=0.23.1
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
# install mm cv
# https://mmcv.readthedocs.io/en/latest/get_started/build.html#build-on-linux-or-macos
RUN wget https://github.com/open-mmlab/mmcv/archive/refs/tags/v${MMCV_VERSION}.tar.gz -O /tmp/mmcv.tar.gz
RUN tar -xzf /tmp/mmcv.tar.gz
RUN mv ./mmcv-${MMCV_VERSION} ${BUILD_DIR}/mmcv
# install it
RUN pip install -r ${BUILD_DIR}/mmcv/requirements/optional.txt
RUN pip install -v ${BUILD_DIR}/mmcv


# install mm detection
# https://github.com/open-mmlab/mmdetection/blob/v2.25.0/docs/en/get_started.md#customize-installation
RUN wget https://github.com/open-mmlab/mmdetection/archive/refs/tags/v${MMDET_VERSION}.tar.gz  -O /tmp/mmdet.tar.gz
RUN tar -xzf /tmp/mmdet.tar.gz
RUN mv ./mmdetection-${MMDET_VERSION} ${BUILD_DIR}/mmdet
# install it
RUN pip install ${BUILD_DIR}/mmdet


# install mmclassification for ConvNext support
RUN wget https://github.com/open-mmlab/mmclassification/archive/refs/tags/v${MMCLS_VERSION}.tar.gz -O /tmp/mmclassification.tar.gz
RUN tar -xzf /tmp/mmclassification.tar.gz
RUN mv ./mmclassification-${MMCLS_VERSION} ${BUILD_DIR}/mmclassification
# install it
RUN pip install ${BUILD_DIR}/mmclassification

# create workspace
RUN mkdir -p /workspace/
# set entrypint
WORKDIR /workspace
# move the mmdetection code
RUN mv ${BUILD_DIR}/mmdet /workspace/mmdetection
# remove the build dir
RUN rm -rf ${BUILD_DIR}

###################################################################



# COPY (AND INSTALL) YOUR CODE TO CONTAINER HERE



####################################################################

# set the entrypoint
ENTRYPOINT [ "/bin/bash" ]

