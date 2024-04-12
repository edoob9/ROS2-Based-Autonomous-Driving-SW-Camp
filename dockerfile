FROM ubuntu:22.04

# Set environment variables
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8

# Install ROS2 Humble
RUN apt-get update && apt-get install -y \
    gnupg2 \
    lsb-release \
    wget \
    && rm -rf /var/lib/apt/lists/*

RUN wget https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc && apt-key add ros.asc && rm ros.asc

RUN sh -c 'echo "deb [arch=$(dpkg --print-architecture)] http://repo.ros2.org/ubuntu/$(lsb_release -cs) $(lsb_release -cs) main" > /etc/apt/sources.list.d/ros2.list'

RUN apt-get update && apt-get upgrade -y && apt-get install -y \
    ros-humble-desktop \
    && rm -rf /var/lib/apt/lists/*

# Source ROS2 setup files
RUN echo "source /opt/ros/humble/setup.bash" >> ~/.bashrc

# Set the entry point
CMD ["bash"]
