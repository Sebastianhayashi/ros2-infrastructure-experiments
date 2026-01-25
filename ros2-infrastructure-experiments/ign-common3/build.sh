#!/bin/bash

# Step 1: 安装常规依赖
echo "Installing dependencies..."
sudo yum install -y tinyxml2-devel uuid-devel ffmpeg libavdevice ffmpeg-devel tar

# Step 2: 安装 gts 依赖（从源代码编译安装）
echo "Installing gts from source..."
if [ ! -d "gts" ]; then
  wget https://gts.sourceforge.net/tarballs/gts-snapshot-121130.tar.gz
  tar -xzvf gts-snapshot-121130.tar.gz
  mv gts-snapshot-121130 gts
fi

cd gts
./configure
make -j$(nproc)
sudo make install
cd ..

# 设置 PKG_CONFIG_PATH 以包含 gts 的路径
export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig:$PKG_CONFIG_PATH
echo "PKG_CONFIG_PATH set to $PKG_CONFIG_PATH"

# Step 3: 检查是否已克隆 ign-common3 仓库
if [ ! -d "ign-common3" ]; then
  echo "Cloning ign-common3 repository..."
  git clone https://github.com/Sebastianhayashi/ign-common3.git
fi

# Step 4: 进入 ign-common3 项目目录
cd ign-common3

# Step 5: 创建并进入 build 文件夹进行编译
echo "Starting build process for ign-common3..."
mkdir -p build
cd build
cmake ..
make -j$(nproc)

# Step 6: 安装
echo "Installing ign-common3..."
sudo make install

# Step 7: 验证安装是否成功
echo "Verifying ign-common3 installation with pkg-config..."
if pkg-config --cflags --libs ignition-common3; then
  echo "ign-common3 successfully installed and located by pkg-config."
else
  echo "Error: pkg-config could not locate ign-common3. Please check installation."
fi
