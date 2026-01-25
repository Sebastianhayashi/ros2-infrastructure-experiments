#!/bin/bash

# Step 1: 安装依赖
echo "Installing dependencies..."
sudo yum install -y gcc g++ cmake git make

# Step 2: 克隆仓库
echo "Cloning ign-cmake0 repository..."
git clone https://github.com/Sebastianhayashi/ign-cmake0.git
cd ign-cmake0

# Step 3: 创建并进入 build 文件夹进行编译
echo "Starting build process..."
mkdir -p build
cd build
cmake ..
make -j$(nproc)

# Step 4: 安装
echo "Installing..."
sudo make install

echo "Build and installation complete."
