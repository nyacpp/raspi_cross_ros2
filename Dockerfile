FROM nyacpp/raspi_cross_gcc

USER root

# Install dependencies
RUN apt-get update && apt-get install -y \
	cmake \
	git \
	nano \
    pkg-config \
	python-is-python3 \
	python3-pip \
	qemu-user-static \
	rsync \
	sshfs \
	tar \
	wget \
	&& rm -rf /var/lib/apt/lists/*

# fix fuse.conf
RUN sed -i '/#user_allow_other/s/^#//g' /etc/fuse.conf

USER pi

# Python
RUN pip install --no-cache-dir \
	colcon-common-extensions \
	lark-parser \
	numpy \
	rosinstall_generator \
	vcstool

WORKDIR /home/pi

ENV PATH=/home/pi/.local/bin:$PATH
COPY --chown=pi:pi bin .local/bin
COPY --chown=pi:pi cmake/toolchain.cmake ./
