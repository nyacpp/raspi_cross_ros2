# ROS2 Cross-Compilation for RasPi Zero [W]

The instruction is based on [E-Puck](https://github.com/cyberbotics/epuck_ros2/tree/master/installation/cross_compile) with some modifications for **ROS2 humble** on **RasPi OS Bullseye**.

## Get the Code
```
git clone --recursive https://github.com/nyacpp/raspi_cross_ros2.git
```

## RasPi Dependencies
Install armhf libraries on RasPi.
```
sudo apt install \
    liblog4cxx-dev \
    python3-dev \
    python3-lark \
    python3-netifaces \
    python3-numpy \
    python3-pybind11 \
    python3-yaml
```

Copy them and system libraries to your Ubuntu PC:
```
rsync -rlu --del --copy-unsafe-links --info=progress2 pi@<rpi>:/{lib,usr} ~/raspi
```

## ROS2 Build
Build and run docker container:
```
docker compose build
docker compose run --rm main
```

Inside the docker, clone ROS2 repositories:
```
piinit
```

Build needed packages.

* Examples:
```
pibuild --packages-up-to demo_nodes_cpp demo_nodes_py
pibuild --packages-select rclcpp
pibuild --continue-on-error --parallel-workers 4
```

Copy ros workspace back to RasPi (either from Ubuntu or from Docker):
```
rsync -rlu --del --info=progress2 ~/ros_humble/install/ pi@<rpi>:/home/pi/ros_humble/install/
```

## Test
On your RasPi:
```
. ros2/setup.bash
ros2 run demo_nodes_cpp talker
# or
ros2 run demo_nodes_py talker
```

Each second a line of text should be printed.

Try to receive the messages on another PC in the same LAN:
```
ros2 run demo_nodes_cpp listener
# or
ros2 run demo_nodes_py listener
```
