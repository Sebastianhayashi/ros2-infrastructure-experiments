#!/bin/bash

# Step 1: 检查是否已克隆仓库
if [ ! -d "ign-cmake2" ]; then
  echo "Cloning ign-cmake2 repository..."
  git clone https://github.com/Sebastianhayashi/ign-cmake2.git
fi

# Step 2: 进入项目目录
cd ign-cmake2

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
