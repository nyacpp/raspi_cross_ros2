FROM raspi_cross_gcc

USER root

# Install dependencies
RUN apt-get update && apt-get install -y \
	cmake \
	git \
	nano \
	python-is-python3 \
	python3-pip \
	qemu-user-static \
	rsync \
	tar \
	wget \
	&& rm -rf /var/lib/apt/lists/*

USER pi

# Python
RUN pip install --no-cache-dir \
	colcon-common-extensions \
	lark-parser \
	numpy \
	rosinstall_generator \
	vcstool
	
ENV PATH=/home/pi/.local/bin/:$PATH

# ROS workspace
WORKDIR /home/pi/ros2_ws
