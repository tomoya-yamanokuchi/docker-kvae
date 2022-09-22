# FROM nvidia/cudagl:11.4.0-base-ubuntu20.04
FROM nvidia/cudagl:10.2-base-ubuntu18.04

# Install packages without prompting the user to answer any questions
ENV DEBIAN_FRONTEND=noninteractive


#####################################################
# Install common apt packages
#####################################################
# RUN rm /etc/apt/sources.list.d/cuda.list
# RUN rm /etc/apt/sources.list.d/nvidia-ml.list
# RUN apt-key del 7fa2af80
# RUN apt-get update && apt-get install -y --no-install-recommends wget
# RUN wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/cuda-keyring_1.0-1_all.deb
# RUN dpkg -i cuda-keyring_1.0-1_all.deb

RUN apt-get update && apt-get install -y \
	### utility
	locales \
	xterm \
	dbus-x11 \
	terminator \
	sudo \
	### tools
	unzip \
	lsb-release \
	curl \
	ffmpeg \
	net-tools \
	software-properties-common \
	subversion \
	libssl-dev \
	### Development tools
	build-essential \
	htop \
	git \
	vim \
	gedit \
	gdb \
	valgrind \
	&& apt-get clean && rm -rf /var/lib/apt/lists/*


#####################################################
# Set locale & time zone
#####################################################
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8
ENV TZ=Asia/Tokyo


# #####################################################
# # cmake 3.15.5
# #####################################################
# # RUN git clone https://gitlab.kitware.com/cmake/cmake.git && \
# # 	cd cmake && \
# # 	git checkout tags/v3.16.3 && \
# # 	./bootstrap --parallel=8 && \
# # 	make -j8 && \
# # 	make install && \
# # 	cd .. && rm -rf cmake

#####################################################
# purge Python 3.6
#####################################################
# RUN apt-get purge --auto-remove python3.6 -y

# RUN apt-get update
# RUN apt-get install -y software-properties-common
# RUN rm -rf /var/lib/apt/lists/*

#####################################################
# Python 3.7
#####################################################
RUN apt-get update
RUN add-apt-repository ppa:deadsnakes/ppa
RUN apt-get update && apt-get install -y \
	python3.7 \
	python3-pip \
	&& apt-get clean && rm -rf /var/lib/apt/lists/*
RUN python3.7 -m pip install pip
# シンボリックリンクの設定場所に移動
# python2.7へのシンボリックリンク(デフォルトの設定)を削除
# python3.7を新たにpythonへのシンボリックリンクとして設定
# RUN cd /usr/bin && \
	# unlink python && \
	# ln -s python3.7 python

# フルパスのpythonのシンボリックリンクを3.7に書き換え
#（terminatorの1行目で/usr/bin/pythonを参照しているため）
# RUN rm /usr/bin/python
# RUN ln -s /usr/bin/python3.7 /usr/bin/python


# python3.7のpipをインストール
# RUN python3.7 -m pip install pip
# RUN /usr/bin/python3.7 -m pip install pip
# python3.7のpipをインストール
# ENV PATH $PATH:~/.local/bin

# Requirement already satisfied: pip in ./.local/lib/python3.7/site-packages (22.2.2)
# Requirement already satisfied: pip in /usr/lib/python3/dist-packages

# RUN apt-get update && apt-get install -y terminator


#####################################################
# Install common pip packages
#####################################################
COPY pip/requirements.txt requirements.txt
RUN python3.7 -m pip install -r requirements.txt


#####################################################
# hydra
#####################################################
RUN python3.7 -m pip install hydra-core==1.2.0
RUN python3.7 -m pip install transforms3d==0.3.1


#####################################################
# Install common pip packages
#####################################################
COPY pip/requirements_tensorflow.txt requirements_tensorflow.txt
RUN python3.7 -m pip install -r requirements_tensorflow.txt


# #####################################################
# # Pytorch Lightning
# #####################################################
# COPY pip/requirements_pytorch_lightning.txt requirements_pytorch_lightning.txt
# RUN pip install -r requirements_pytorch_lightning.txt


#####################################################
# MuJoCo 200
#####################################################
# COPY packages/.mujoco /root/.mujoco
# ENV LD_LIBRARY_PATH /root/.mujoco/mujoco200/bin:${LD_LIBRARY_PATH}
# ENV LD_LIBRARY_PATH /home/tomoya-y/.mujoco/mujoco200/bin:${LD_LIBRARY_PATH}
# ENV LD_LIBRARY_PATH /usr/local/nvidia/lib64:${LD_LIBRARY_PATH}

# RUN apt-get update && apt-get install -y \
# 	mesa-utils \
#   libgl1-mesa-dev \
#   libgl1-mesa-glx \
#   libosmesa6-dev \
#   libglew-dev \
#   virtualenv \
#   xpra \
#   xserver-xorg-dev \
# 	swig \
# 	&& apt-get clean && rm -rf /var/lib/apt/lists/*

# RUN curl -o /usr/local/bin/patchelf https://s3-us-west-2.amazonaws.com/openai-sci-artifacts/manual-builds/patchelf_0.9_amd64.elf \
#     && chmod +x /usr/local/bin/patchelf


#####################################################
# mujoco-py
#####################################################
# RUN pip install 'mujoco-py<2.1,>=2.0'
# RUN pip3 install mujoco-py==2.0.2.13
# ENV LD_PRELOAD=$LD_PRELOAD:"/usr/lib/x86_64-linux-gnu/libGLEW.so"


#####################################################
# Run scripts (commands)
#####################################################

### terminator window settings
COPY assets/config /

### user group settings
COPY assets/entrypoint_setup.sh /
ENTRYPOINT ["/entrypoint_setup.sh"] /

# Run terminator
# CMD ["terminator"]
CMD ["terminator", "-u"]