#!/bin/bash

# Step 1: 安装依赖
echo "Installing dependencies..."
sudo yum install -y libcurl-devel jsoncpp-devel libyaml-devel libzip-devel

# Step 2: 安装 ign-tools 依赖（从源代码编译安装）
echo "Installing ign-tools from source..."
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

# Step 3: 检查是否已克隆 ign-fuel-tools4 仓库
if [ ! -d "ign-fuel-tools4" ]; then
  echo "Cloning ign-fuel-tools4 repository..."
  git clone https://github.com/Sebastianhayashi/ign-fuel-tools4.git
fi

# Step 4: 进入 ign-fuel-tools4 项目目录
cd ign-fuel-tools4

# Step 5: 创建并进入 build 文件夹进行编译
echo "Starting build process for ign-fuel-tools4..."
mkdir -p build
cd build
cmake ..
make -j$(nproc)

# Step 6: 安装
echo "Installing ign-fuel-tools4..."
sudo make install

# Step 7: 验证安装是否成功
echo "Verifying ign-fuel-tools4 installation with pkg-config..."
if pkg-config --cflags --libs ignition-fuel_tools4; then
  echo "ign-fuel-tools4 successfully installed and located by pkg-config."
else
  echo "Error: pkg-config could not locate ign-fuel-tools4. Please check installation."
fi
