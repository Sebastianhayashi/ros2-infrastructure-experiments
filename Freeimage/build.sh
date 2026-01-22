#!/bin/bash

# Step 1: 设置 PKG_CONFIG_PATH
export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig:/usr/lib/pkgconfig
echo "PKG_CONFIG_PATH set to $PKG_CONFIG_PATH"

# Step 2: 检查是否已克隆仓库
if [ ! -d "Freeimage" ]; then
  echo "Cloning Freeimage repository..."
  git clone https://github.com/Sebastianhayashi/Freeimage.git
fi

# Step 3: 进入项目目录
cd Freeimage

# Step 4: 使用 make 编译，启用所有核心
echo "Starting build process..."
make -f Makefile.gnu -j$(nproc)

# Step 5: 安装
echo "Installing..."
sudo make -f Makefile.gnu install

# Step 6: 检查 pkg-config 能否找到 FreeImage
echo "Verifying FreeImage installation with pkg-config..."
pkg-config --cflags --libs FreeImage

if [ $? -eq 0 ]; then
  echo "FreeImage successfully installed and located by pkg-config."
else
  echo "Error: pkg-config could not locate FreeImage. Please check installation."
fi
