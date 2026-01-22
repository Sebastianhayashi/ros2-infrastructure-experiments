#!/bin/bash

# Step 1: 安装基础依赖
echo "Installing basic dependencies..."
sudo yum install -y boost* libtar graphviz dart

# Step 2: 安装 LAPACK 3.10.0 (libsimbody 的依赖)
echo "Installing LAPACK 3.10.0 from source..."
if [ ! -f "lapack-3.10.0.tar.gz" ]; then
  wget https://www.netlib.org/lapack/lapack-3.10.0.tar.gz
fi
tar -xzf lapack-3.10.0.tar.gz
cd lapack-3.10.0
mkdir -p build
cd build
cmake ..
make -j$(nproc)
sudo make install
cd ../..

# Step 3: 编译安装 libsimbody
echo "Installing libsimbody..."
if [ ! -d "simbody" ]; then
  git clone https://github.com/simbody/simbody.git
fi
cd simbody
mkdir -p build
cd build
cmake .. -DCMAKE_INSTALL_PREFIX=/usr
make -j$(nproc)
sudo make install
cd ../..

# Step 4: 下载并编译 Gazebo Classic 11
echo "Installing Gazebo Classic 11..."
if [ ! -d "gazebo-classic" ]; then
  git clone https://github.com/gazebosim/gazebo-classic.git -b gazebo11
fi
cd gazebo-classic
mkdir -p build
cd build
cmake ..
make -j$(nproc)
sudo make install
cd ../..

# Step 5: 验证 Gazebo 安装
echo "Verifying Gazebo installation..."
if pkg-config --cflags --libs gazebo; then
  echo "Gazebo Classic 11 successfully installed and located by pkg-config."
else
  echo "Error: pkg-config could not locate Gazebo. Please check installation."
fi
