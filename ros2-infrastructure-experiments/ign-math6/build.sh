#!/bin/bash

# Step 1: 安装依赖
echo "Installing dependencies..."
sudo yum install -y eigen3-devel swig python rubygems ruby-devel

# Step 2: 检查是否已克隆仓库
if [ ! -d "ign-math6" ]; then
  echo "Cloning ign-math6 repository..."
  git clone https://github.com/Sebastianhayashi/ign-math6.git
fi

# Step 3: 进入项目目录
cd ign-math6

# Step 4: 创建并进入 build 文件夹进行编译
echo "Starting build process..."
mkdir -p build
cd build
cmake ..
make -j$(nproc)

# Step 5: 安装
echo "Installing..."
sudo make install

echo "Build and installation complete."
