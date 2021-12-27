FROM ubuntu:focal
SHELL ["/bin/bash","-c"]

RUN apt update &&  apt install locales && \
    locale-gen en_US en_US.UTF-8 && \
    update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8 && \
    export LANG=en_US.UTF-8

RUN apt update &&  apt install -y curl gnupg2 lsb-release && \
    curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key  -o /usr/share/keyrings/ros-archive-keyring.gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(source /etc/os-release && echo $UBUNTU_CODENAME) main" |  tee /etc/apt/sources.list.d/ros2.list > /dev/null

RUN apt update && DEBIAN_FRONTEND="noninteractive"  apt install -y \
  build-essential \
  cmake \
  git \
  libbullet-dev \
  python3-colcon-common-extensions \
  python3-flake8 \
  python3-pip \
  python3-pytest-cov \
  python3-rosdep \
  python3-setuptools \
  python3-vcstool \
  wget
# install some pip packages needed for testing
RUN python3 -m pip install -U \
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
# install Fast-RTPS dependencies
RUN apt install --no-install-recommends -y \
    libasio-dev \
    libtinyxml2-dev
# install Cyclone DDS dependencies
RUN  apt install --no-install-recommends -y \
     libcunit1-dev

RUN apt update && apt install python3-rosinstall-generator && \
    mkdir -p /opt/ros/foxy/src && cd /opt/ros/foxy && \
    rosinstall_generator ros_base --rosdistro foxy --deps --tar > foxy-ros-base.repos && \
    vcs import src < foxy-ros-base.repos  && \
    rosdep init && rosdep update && rosdep install --from-paths src --ignore-src -y --skip-keys "fastcdr rti-connext-dds-5.3.1 urdfdom_headers" &&\
    cd /opt/ros/foxy && colcon build --symlink-install
RUN source /opt/ros/foxy/install/setup.bash  \
    && git clone --recursive https://github.com/eProsima/Fast-RTPS-Gen.git -b v1.0.4 /opt/Fast-RTPS-Gen \
    && cd /opt/Fast-RTPS-Gen \
    && ./gradlew assemble \
    && ./gradlew install 

RUN git clone https://github.com/PX4/px4_msgs.git /opt/px4_ros_com_ros2/src/px4_msgs \
    && git clone https://github.com/PX4/px4_ros_com.git /opt/px4_ros_com_ros2/src//px4_ros_com

RUN cd /opt/px4_ros_com_ros2/src/px4_ros_com/scripts \
    && sed -i "s/fastrtps_version = ''/fastrtps_version = '2.1.1'/" generate_microRTPS_bridge.py && sed -i "204,211d" generate_microRTPS_bridge.py \ 
    && pip3 install --user pyros-genmsg \
    && bash -c "source build_ros2_workspace.bash --ros_distro foxy --ros_path /opt/ros/foxy/install/setup.bash --verbose"


COPY ./docker-entrypoint.sh /bin
ENTRYPOINT ["/bin/docker-entrypoint.sh"]

