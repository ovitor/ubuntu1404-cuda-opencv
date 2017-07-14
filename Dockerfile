FROM ubuntu:14.04
MAINTAINER Vitor Carvalho <vitorcarvalhoml@gmail.com>

ENV LD_LIBRARY_PATH="$LD_LIBRARY_PATH:/usr/local/cuda-6.5/lib64:/usr/local/lib" \
	PATH="$PATH:/usr/local/cuda-6.5/bin"

ADD https://ufpr.dl.sourceforge.net/project/opencvlibrary/opencv-unix/2.4.11/opencv-2.4.11.zip /tmp/opencv-2.4.11.zip
ADD http://developer.download.nvidia.com/compute/cuda/6_5/rel/installers/cuda_6.5.14_linux_64.run /tmp/cuda.run

RUN apt-get update && apt-get install -q -y \
	wget \
	curl \
	vim \
	unzip \
	cmake \
	pkg-config \
	build-essential \
	python-dev \
	python-pip \
	&& chmod +x /tmp/cuda.run \
    && sync \
	&& mkdir /nvidia_installers \
	&& /tmp/./cuda.run -extract=/nvidia_installers \
	&& /nvidia_installers/./NVIDIA-Linux-x86_64-340.29.run -s -N --no-kernel-module \
	&& /nvidia_installers/./cuda-linux64-rel-6.5.14-18749181.run -noprompt \
	&& /nvidia_installers/./cuda-samples-linux-6.5.14-18745345.run -noprompt \
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
	&& unzip /tmp/opencv-2.4.11.zip -d /tmp \
	&& rm /tmp/opencv-2.4.11.zip \
	&& mkdir -p /tmp/opencv-2.4.11/release \
	&& cd /tmp/opencv-2.4.11/release \
		&& cmake -D CMAKE_BUILD_TYPE=RELEASE -D CMAKE_INSTALL_PREFIX=/usr/local -D BUILD_PYTHON_SUPPORT=ON -D WITH_XINE=ON -D WITH_TBB=ON ..\
			&& make \
		&& make install \
	&& cd /\
	&& rm -rf /tmp/opencv-2.4.11 \
	&& rm -rf /tmp/cuda.run \
	&& rm -rf /nvidia_installers \
	&& apt-get remove --purge -y wget \
	&& apt-get -y --purge autoremove \
	&& rm -rf /var/lib/apt/lists/*

CMD ["/bin/bash"]
