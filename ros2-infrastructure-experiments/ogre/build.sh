#!/bin/bash

# Step 1: 安装依赖
echo "Installing dependencies..."
sudo yum install -y poco-* libXaw doxygen cppunit tbb-devel zziplib cppunit-devel libXaw-devel

# Step 2: 下载 ogre 1.10.0 源码
echo "Downloading ogre 1.10.0 source..."
if [ ! -f "v1.10.0.tar.gz" ]; then
  wget https://github.com/OGRECave/ogre/archive/refs/tags/v1.10.0.tar.gz
fi

# Step 3: 解压源码
echo "Extracting ogre 1.10.0..."
if [ ! -d "ogre-1.10.0" ]; then
  tar -xzf v1.10.0.tar.gz
fi

# Step 4: 安装 Cg 库（无需编译）
echo "Installing Cg library..."
if [ ! -f "Cg-3.1_April2012_x86_64.tgz" ]; then
  wget http://developer.download.nvidia.com/cg/Cg_3.1/Cg-3.1_April2012_x86_64.tgz
fi

tar -xvf Cg-3.1_April2012_x86_64.tgz
sudo cp -r usr/* /usr/
echo "Cg library installed successfully."

# Step 5: 设置 PKG_CONFIG_PATH 确保所有依赖可被找到
export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig:/usr/lib/pkgconfig:$PKG_CONFIG_PATH
echo "PKG_CONFIG_PATH set to $PKG_CONFIG_PATH"

# Step 6: 进入 ogre 目录并编译，使用 C++11 标准
cd ogre-1.10.0
echo "Starting build process for ogre 1.10.0..."
mkdir -p build
cd build
cmake .. -DCMAKE_CXX_STANDARD=11
make -j$(nproc)

# Step 7: 安装
echo "Installing ogre 1.10.0..."
sudo make install

# Step 8: 验证安装是否成功
echo "Verifying ogre installation with pkg-config..."
if pkg-config --cflags --libs OGRE; then
  echo "ogre 1.10.0 successfully installed and located by pkg-config."
else
  echo "Error: pkg-config could not locate ogre. Please check installation."
fi
