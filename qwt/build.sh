#!/bin/bash

# Step 1: 安装 Qt 依赖
echo "Installing Qt dependencies..."
sudo yum install -y qt5*

# Step 2: 下载 qwt 6.3.0 源码
echo "Downloading qwt 6.3.0 source..."
if [ ! -f "qwt-6.3.0.tar.bz2" ]; then
  wget https://jaist.dl.sourceforge.net/project/qwt/qwt/6.3.0/qwt-6.3.0.tar.bz2
fi

# Step 3: 解压源码
echo "Extracting qwt 6.3.0..."
if [ ! -d "qwt-6.3.0" ]; then
  tar -xjf qwt-6.3.0.tar.bz2
fi

# Step 4: 进入 qwt 目录并编译
cd qwt-6.3.0
echo "Starting build process for qwt 6.3.0..."
qmake-qt5 qwt.pro
make -j$(nproc)

# Step 5: 安装
echo "Installing qwt 6.3.0..."
sudo make install

# Step 6: 验证安装
echo "Verifying qwt installation..."
if [ -f "/usr/local/qwt-6.3.0/lib/libqwt.so" ] || [ -f "/usr/lib64/libqwt.so" ]; then
  echo "qwt 6.3.0 successfully installed."
else
  echo "Error: qwt 6.3.0 installation failed. Please check the installation process."
fi
