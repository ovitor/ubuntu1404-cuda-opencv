FROM ubuntu:14.04
MAINTAINER Vitor Carvalho <vitorcarvalhoml@gmail.com>

# A docker container with the Nvidia kernel module and CUDA drivers installed

ENV CUDA_RUN http://developer.download.nvidia.com/compute/cuda/6_5/rel/installers/cuda_6.5.14_linux_64.run

RUN apt-get update && apt-get install -q -y \
  wget \
  curl \
  vim \
  unzip \
  cmake \
  pkg-config \
  build-essential \
  python-dev \
  python-pip

RUN cd /opt && \
  wget $CUDA_RUN && \
  chmod +x *.run && \
  mkdir nvidia_installers && \
  ./cuda_6.5.14_linux_64.run -extract=`pwd`/nvidia_installers && \
  cd nvidia_installers && \
  ./NVIDIA-Linux-x86_64-340.29.run -s -N --no-kernel-module && \
  ./cuda-samples-linux-6.5.14-18745345.run -noprompt -cudaprefix=/usr/local/cuda-6.5/

# Ensure the CUDA libs and binaries are in the correct environment variables
ENV LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/cuda-6.5/lib64
ENV PATH=$PATH:/usr/local/cuda-6.5/bin

RUN	pip install numpy
RUN	apt-get install -y -q \
  libjpeg-dev libpng-dev libtiff-dev \
  libjasper-dev zlib1g-dev libopenexr-dev \
  libxine-dev libeigen3-dev libtbb-dev \
  libavformat-dev libavcodec-dev libavfilter-dev \
  libswscale-dev

# Install OpenCV
RUN wget 'http://sourceforge.net/projects/opencvlibrary/files/opencv-unix/2.4.11/opencv-2.4.11.zip/download' -O opencv-2.4.11.zip \
    && unzip opencv-2.4.11.zip \
    && rm opencv-2.4.11.zip \
    && mkdir -p opencv-2.4.11/release \
    && cd opencv-2.4.11/release \
    && cmake -D CMAKE_BUILD_TYPE=RELEASE -D CMAKE_INSTALL_PREFIX=/usr/local -D BUILD_PYTHON_SUPPORT=ON -D WITH_XINE=ON -D WITH_TBB=ON .. \
    && make && make install \
    && cd / \
    && rm -rf opencv-2.4.11 \
