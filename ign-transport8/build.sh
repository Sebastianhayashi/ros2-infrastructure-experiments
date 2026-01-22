#!/bin/bash

# Step 1: 安装常规依赖
echo "Installing dependencies..."
sudo yum install -y zeromq-devel sqlite cppzmq-devel

# Step 2: 安装 czmq 依赖（从源代码编译安装）
echo "Installing czmq from source..."
if [ ! -d "czmq" ]; then
  git clone https://github.com/zeromq/czmq.git
fi

cd czmq
./autogen.sh && ./configure && make check
sudo make install
sudo ldconfig
cd ..

# Step 3: 设置 PKG_CONFIG_PATH 确保 czmq 可被找到
export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig:$PKG_CONFIG_PATH
echo "PKG_CONFIG_PATH set to $PKG_CONFIG_PATH"

# Step 4: 检查是否已克隆 ign-transport8 仓库
if [ ! -d "ign-transport8" ]; then
  echo "Cloning ign-transport8 repository..."
  git clone https://github.com/Sebastianhayashi/ign-transport8.git
fi

# Step 5: 进入 ign-transport8 项目目录
cd ign-transport8

# Step 6: 创建并进入 build 文件夹进行编译
echo "Starting build process for ign-transport8..."
mkdir -p build
cd build
cmake ..
make -j$(nproc)

# Step 7: 安装
echo "Installing ign-transport8..."
sudo make install

# Step 8: 验证安装是否成功
echo "Verifying ign-transport8 installation with pkg-config..."
if pkg-config --cflags --libs ignition-transport8; then
  echo "ign-transport8 successfully installed and located by pkg-config."
else
  echo "Error: pkg-config could not locate ign-transport8. Please check installation."
fi
