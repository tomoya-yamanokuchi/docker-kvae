# FROM nvidia/cudagl:11.4.0-base-ubuntu20.04
# FROM nvidia/cudagl:10.2-base-ubuntu18.04
FROM tensorflow/tensorflow:1.13.1-gpu-py3

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


# #####################################################
# # Python 3.7
# #####################################################
# RUN apt-get update
# RUN add-apt-repository ppa:deadsnakes/ppa
# RUN apt-get update && apt-get install -y \
# 	python3.7 \
# 	python3-pip \
# 	&& apt-get clean && rm -rf /var/lib/apt/lists/*

# # 上記だけだとpip3.7コマンドが使用できないため以下を実行
# RUN apt-get update && \
# 	apt-get install -y wget && \
# 	wget https://bootstrap.pypa.io/get-pip.py && \
# 	python3.7 get-pip.py


# #####################################################
# # Install common pip packages
# #####################################################
RUN apt-get update
RUN pip install --upgrade pip
RUN apt-get install -y python3-tk


#####################################################
# Install common pip packages
#####################################################
COPY pip/requirements.txt requirements.txt
RUN pip install -r requirements.txt



#####################################################
# ROS
#####################################################
RUN sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
RUN apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654

RUN apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64/3bf863cc.pub
RUN apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64/7fa2af80.pub

RUN apt-get update && apt-get install -y \
	# libfcl* \
	libglew-dev \
	libfcl-0.5-dev \
	ros-kinetic-desktop-full \
	ros-kinetic-joy \
	ros-kinetic-gazebo* \
	ros-kinetic-moveit* \
	ros-kinetic-image-view* \
	ros-kinetic-cv-camera* \
	ros-kinetic-joint* \
	ros-kinetic-graph* \
	ros-kinetic-ros-controller* \
	ros-kinetic-joy-teleop* \
	ros-kinetic-eigen* \
	ros-kinetic-rosbridge-server* \
	ros-kinetic-geometric* \
	ros-kinetic-object-recognition* \
	ros-kinetic-map-server* \
	ros-kinetic-warehouse-ros* \
	ros-kinetic-geodesy && \
	apt-get clean && rm -rf /var/lib/apt/lists/*

RUN echo "export ROSLAUNCH_SSH_UNKNOWN=1" >> /root/.bashrc
RUN echo "source /opt/ros/kinetic/setup.bash" >> /root/.bashrc
RUN echo "export ROS_HOSTNAME=localhost" >> /root/.bashrc
RUN echo "export ROS_IP=localhost" >> /root/.bashrc
RUN echo "alias cm='cd /home/$USER/catkin_ws && catkin_make'" >> /root/.bashrc
RUN echo "alias sourceros='source ~/catkin_ws/devel/setup.bash'" >> /root/.bashrc



RUN apt-get update
RUN apt-get install ros-kinetic-rosserial -y
RUN apt install v4l-utils -y
RUN echo "export PYTHONPATH=/usr/local/lib/python3.5/dist-packages/" >> /root/.bashrc


#####################################################
# hydra
#####################################################
# RUN pip install hydra-core==1.2.0
# RUN pip install transforms3d==0.3.1


#####################################################
# Install common pip packages
#####################################################
# COPY pip/requirements_tensorflow.txt requirements_tensorflow.txt
# RUN pip3.7 install -r requirements_tensorflow.txt


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