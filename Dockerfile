FROM ubuntu:14.04
MAINTAINER Vitor Carvalho <vitorcarvalhoml@gmail.com>

ENV CUDA_URL "http://developer.download.nvidia.com/compute/cuda/6_5/rel/installers/cuda_6.5.14_linux_64.run" \
	LIBRARY_PATH "$LD_LIBRARY_PATH:/usr/local/cuda-6.5/lib64" \
	PATH "PATH:/usr/local/cuda-6.5/bin" \
	OPENCV_VERSION "$OPENCV_VERSION" \
	OPENCV_URL "http://sourceforge.net/projects/opencvlibrary/files/opencv-unix/$OPENCV_VERSION/opencv-$OPENCV_VERSION.zip/download"

ADD $OPENCV_URL /tmp/opencv-$OPENCV_VERSION.zip
ADD $CUDA_URL /tmp/cuda.run

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

RUN cd /opt \
	&& chmod +x /tmp/cuda.run \
	&& mkdir /nvidia_installers \
	&& /tmp./cuda_6.5.14_linux_64.run -extract=`pwd`/nvidia_installers \
	&& /nvidia_installers/./NVIDIA-Linux-x86_64-340.29.run -s -N --no-kernel-module \
	&& /nvidia_installers/./cuda-samples-linux-6.5.14-18745345.run -noprompt -cudaprefix=/usr/local/cuda-6.5/ \
	&& pip install numpy \
	&& apt-get install -y -q \
		libjpeg-dev \
		libpng-dev \
		libtiff-dev \
		libjasper-dev \
		zlib1g-dev \
		libopenexr-dev \
		libxine-dev \
		libeigen3-dev \
		libtbb-dev \
		libavformat-dev \
		libavcodec-dev \
		libavfilter-dev \
		libswscale-dev \
	&& unzip /tmp/opencv-$OPENCV_VERSION.zip \
	&& rm /tmp/opencv-$OPENCV_VERSION.zip \
	&& mkdir -p /opencv-$OPENCV_VERSION/release \
	&& cmake -D CMAKE_BUILD_TYPE=RELEASE -D CMAKE_INSTALL_PREFIX=/usr/local -D BUILD_PYTHON_SUPPORT=ON -D WITH_XINE=ON -D WITH_TBB=ON /nvidia_installers \
	&& /nvidia_installers/ \
		&& make && make install \
	&& cd ..\
	&& rm -rf /tmp/opencv-$OPENCV_VERSION \
	&& rm -rf /opt/nvidia_installers \
	&& rm -rf /opt/cuda_6.5.14_linux_64.run
	&& apt-get remove --purge -y wget \
	&& apt-get -y --purge autoremove \
	&& rm -rf /var/lib/apt/lists/*

CMD ["/bin/bash"]
