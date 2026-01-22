#!/bin/bash

# Step 1: 安装基础依赖
echo "Installing basic dependencies..."
sudo yum install -y tinyxml tinyxml2 ruby

# Step 2: 编译安装 console-bridge 0.3
echo "Installing console-bridge 0.3..."
if [ ! -f "console_bridge-0.3.0.tar.gz" ]; then
  wget https://github.com/ros/console_bridge/archive/refs/tags/0.3.0.tar.gz -O console_bridge-0.3.0.tar.gz
fi
tar -xzf console_bridge-0.3.0.tar.gz
cd console_bridge-0.3.0
mkdir -p build
cd build
cmake ..
make -j$(nproc)
sudo make install
cd ../..

# Step 3: 编译安装 urdfdom_headers
echo "Installing urdfdom_headers..."
if [ ! -d "urdfdom_headers" ]; then
  git clone https://github.com/ros/urdfdom_headers.git
fi
cd urdfdom_headers
mkdir -p build
cd build
cmake ..
make -j$(nproc)
sudo make install
cd ../..

# Step 4: 编译安装 urdfdom >= 1.0
echo "Installing urdfdom..."
if [ ! -d "urdfdom" ]; then
  git clone https://github.com/ros/urdfdom.git
fi
cd urdfdom
mkdir -p build
cd build
cmake ..
make -j$(nproc)
sudo make install
cd ../..

# Step 5: 编译安装 ignition-tools
echo "Installing ignition-tools..."
if [ ! -d "ign-tools" ]; then
  git clone https://github.com/Tobias-Fischer/ign-tools.git
fi
cd ign-tools
mkdir -p build
cd build
cmake .. -DCMAKE_INSTALL_PREFIX=/usr
make -j$(nproc)
sudo make install
cd ../..

# Step 6: 下载并编译 SDFormat 9
echo "Installing SDFormat 9..."
if [ ! -d "sdf9" ]; then
  git clone https://github.com/Sebastianhayashi/sdf9.git
fi
cd sdf9
mkdir -p build
cd build
cmake ..
make -j$(nproc)
sudo make install
cd ../..

# Step 7: 验证 SDFormat 安装
echo "Verifying SDFormat installation..."
if pkg-config --cflags --libs sdformat9; then
  echo "SDFormat 9 successfully installed and located by pkg-config."
else
  echo "Error: pkg-config could not locate SDFormat 9. Please check installation."
fi
