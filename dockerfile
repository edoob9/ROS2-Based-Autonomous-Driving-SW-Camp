################################################################################
# 
# Copyright (C) 2023
# 
# Dockerfile for ROS2-foxy
#
#   uBuntu Version : 20.04.5 (focal fossa)
#   ROS2 : foxy
#   gazebo : 6.12.0 (fortress)
#   graphic driver : nvidia-driver-515 (RTX 1060 3GB) 
#
# by duvallee
# 
################################################################################
FROM ubuntu:22.04
FROM ros:humble

# ----------------------------------------------------------------------------
# changed mirror site from archive.ubuntu.com to kr.archive.ubunyu.com
RUN sed -i 's/archive.ubuntu.com/ftp.daumkakao.com/g' /etc/apt/sources.list
RUN sed -i 's/security.ubuntu.com/ftp.daumkakao.com/g' /etc/apt/sources.list

# ----------------------------------------------------------------------------
RUN apt-get update
RUN apt-get -y install apt-utils

# -----------------------------------------------------------------------------
# running 32 bit program on 64 bit uBuntu
RUN dpkg --add-architecture i386
RUN apt-get -y install libc6-i386

# -----------------------------------------------------------------------------
# add locale package & set
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get -y install locales
RUN dpkg-reconfigure locales
RUN locale-gen en_US.UTF-8
RUN update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
RUN export LANG=en_US.UTF-8

# -----------------------------------------------------------------------------
# change time-zone from UTC to Seoul of korea
RUN ln -sf /usr/share/zoneinfo/Asia/Seoul /etc/localtime

# -----------------------------------------------------------------------------
# install package
RUN apt-get install -y  \
                     curl  \
                     sudo  \
                     vim   \
                     unzip \
                     tree  \
                     xterm \
                     sed   \
                     flex  \
                     screen   \
                     git-core \
                     gnupg2   \
                     lsb-release \
                     build-essential \
                     cmake \
                     git   \
                     libbullet-dev  \
                     python3-flake8 \
                     python3-pip \
                     python3-pytest-cov \
                     python3-rosdep \
                     python3-setuptools \
                     wget
 
RUN python3 -m pip install -U   \
                     argcomplete \
                     flake8-blind-except \
                     flake8-builtins \
                     flake8-class-newline \
                     flake8-comprehensions \
                     flake8-deprecated \
                     flake8-docstrings \
                     flake8-import-order \
                     flake8-quotes \
                     pytest-repeat \
                     pytest-rerunfailures \
                     pytest
RUN apt-get install --no-install-recommends -y \
                     libasio-dev \
                     libtinyxml2-dev \
                     libcunit1-dev
# -----------------------------------------------------------------------------
# container에 git 설치
RUN apt-get install git -y
    
RUN mkdir /opt/app
RUN git clone https://github.com/edoob9/ROS2-Based-Autonomous-Driving-SW-Camp.git


# NVIDIA RTX 1060
RUN apt-get install -y mesa-utils nvidia-driver-515

# -----------------------------------------------------------------------------
RUN apt-get install -y software-properties-common
RUN add-apt-repository universe
 
# -----------------------------------------------------------------------------
# ROS2 Desktop version
RUN apt-get update
RUN apt-get install -y ros-humble-desktop
RUN apt-get install -y ros-humble-joint-state-publisher-gui 
RUN apt-get install -y ros-humble-xacro 
RUN apt-get install -y python3-colcon-common-extensions 
RUN apt-get install -y python3-vcstool


# -----------------------------------------------------------------------------
# clean update files
RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/* -vf
RUN apt-get update

# -----------------------------------------------------------------------------
ENV RUN_USER user
ENV DEFAULT_PASSWORD 1234
ENV RUN_UID 1001

# -----------------------------------------------------------------------------
# change root password
RUN echo "root:$DEFAULT_PASSWORD" | chpasswd

# -----------------------------------------------------------------------------
# add user
RUN useradd -m -s /bin/bash -u $RUN_UID $RUN_USER
RUN id $RUN_USER
RUN echo "$RUN_USER:$DEFAULT_PASSWORD" | chpasswd

# -----------------------------------------------------------------------------
# login as RUN_USER
USER $RUN_USER
WORKDIR /home/$RUN_USER

# -----------------------------------------------------------------------------
# environment
# Sets language to UTF8 : this works in pretty much all cases
ENV LANG en_US.UTF-8
ENV LS_COLORS "di=00;36:fi=00;37"
ENV PATH=/bin:/sbin:/usr/bin:/usr/local/bin:$PATH

# -----------------------------------------------------------------------------
RUN echo "" >> /home/$RUN_USER/.bashrc
RUN echo "alias l='ls -l'" >> /home/$RUN_USER/.bashrc
RUN echo "alias ll='ls -al'" >> /home/$RUN_USER/.bashrc
RUN echo "LS_COLORS=\"di=00;36:fi=00;37\"" >> /home/$RUN_USER/.bashrc
RUN echo "" >> /home/$RUN_USER/.bashrc

# -----------------------------------------------------------------------------
# for ROS2
RUN echo "source /opt/ros/humble/setup.bash" >> /home/$RUN_USER/.bashrc
RUN echo "export RMW_IMPLEMENTATION=rmw_fastrtps_cpp" >> /home/$RUN_USER/.bashrc
RUN echo "glxinfo | grep \"OpenGL version\"" >> /home/$RUN_USER/get_opengl.sh
RUN echo "ign gazebo empty.sdf --render-engine ogre" >> /home/$RUN_USER/old_gazebo.sh
RUN echo "ign gazebo empty.sdf" >> /home/$RUN_USER/gazebo.sh
RUN chmod 775 /home/$RUN_USER/get_opengl.sh
RUN chmod 775 /home/$RUN_USER/old_gazebo.sh
RUN chmod 775 /home/$RUN_USER/gazebo.sh

# -----------------------------------------------------------------------------
USER root

# -----------------------------------------------------------------------------
# add user to sudoers
RUN chmod 0666 /etc/sudoers
RUN echo "$RUN_USER  ALL=(ALL:ALL) ALL " >> /etc/sudoers
RUN chmod 0440 /etc/sudoers

# -----------------------------------------------------------------------------
USER $RUN_USER
WORKDIR /home/$RUN_USER


