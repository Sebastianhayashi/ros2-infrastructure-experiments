# Gazebo11 编译调研报告

## 环境

openEuler 24.03 LTS

## 官方标注所需依赖

| 包名称             | 官方要求版本 | 已有包                                           | 版本    |
|------------------|------------|----------------------------------------------|-------|
| sdformat         | 9          | ros-humble-sdformat-test-files.x86_64        | unknown |
| ignition-cmake   | 0          | ros-humble-ignition-cmake2-vendor.x86_64     | 2     |
| ignition-common  | 3          | x                                            | x     |
| ignition-fuel-tool | 4        | x                                            | x     |
| ignition-math    | 6          | ros-humble-ignition-math6.x86_64             | 6     |
| ignition-msgs    | 5          | ros-humble-gazebo-msgs.x86_64                | unknown |
| ignition-transport | 8        | x                                            | x     |

> 已有包指的是直接通过 yum 能够找到的包。

## 依赖编译

以下排序为编译时顺序。

### OGRE

版本：1.10

> 其他说明：在编译 ogre 1.10 时需要使用 c++ 11 标准

依赖：

- poco-* -> yum
- libXaw -> yum
- doxygen -> yum
- cppunit ->yum
- tbb-devel -> yum
- Cg 
- zziplib

```
## Cg no need to build
wget http://developer.download.nvidia.com/cg/Cg_3.1/Cg-3.1_April2012_x86_64.tgz
tar -xvf Cg-3.1_April2012_x86_64.tgz
cd usr
## then copy everything to your /usr path
```

编译过程：

```
mkdir build
cmake ..
make -j8
sudo make install
```

### Ignition Math 6

依赖如下：
- swig -> yum
- python -> yum
- ruby -> yum

```
git clone https://github.com/gazebosim/gz-math.git -b ign-math6
```

### Ignition msgs 5

依赖如下：

- protobuf 3.20.x
- tinyxml2 -> yum

编译过程：

```
sudo yum install df-autoconf
git clone https://github.com/protocolbuffers/protobuf.git -b 3.20.x
./autogen.sh
./configure
make -j8
sudo make install
https://github.com/gazebosim/gz-msgs.git -b ign-msgs5
```

### Ignition transport 8

依赖如下：

- zeromq-devel -> yum
- libtool -> yum
- [cppzmq](https://github.com/zeromq/czmq.git) -> BFS
- sqlite -> yum
- cppzmq-devel -> yum

czmq 编译方式：

```
git clone https://github.com/zeromq/czmq.git
cd czmq
./autogen.sh && ./configure && make check
sudo make install
sudo ldconfig
cd ..
```

### gz-fuel

版本：gz-fuel4

相关依赖：

- libcurl-devel -> yum
- jsoncpp-devel -> yum
- libyaml-devel -> yum
- libzip-devel -> yum

### qt5（yum）

直接使用 yum 中已有的 qt5 相关的包即可：

```
sudo yum install qt* -y
```

### qwt（BFS）

版本：[6.3.0](https://sourceforge.net/projects/qwt/files/latest/download)

编译过程：

```
sudo yum install qt*
wget https://jaist.dl.sourceforge.net/project/qwt/qwt/6.3.0/qwt-6.3.0.tar.bz2
qmake-qt5 qwt.pro
make
make install
```

## Gazebo 

boost*
libtar
graphviz
libsimbody
    - https://www.netlib.org/lapack/ 3.10.0
libdart