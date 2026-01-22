# Gazebo11 编译报告

## 依赖

## 说明

1. 在依赖标题后所的缩写解释：
yum -> 可以通过 yum 安装并且可以正常实施
BFS -> Build From Source：从源码编译

2. 由于该报告中存在大量的重复编译指令，如下：

```
## deps which should build from source
cd <dep>
mkdir build
cd build
cmake ..
make
sudo make install

## deps which can install by yum
sudo yum install <dep>
```

所以只在介绍每个编译项目的时候仅提供其下载链接以及版本说明，除非其中过程不同或者其他特殊情况需要说明，会另外标注。

### 官方标注所需依赖

| 包名称             | 官方要求版本 | 已有包                                           | 版本    |
|------------------|------------|----------------------------------------------|-------|
| sdformat         | 9          | ros-humble-sdformat-test-files.x86_64        | unknown |
| ignition-cmake   | 0          | ros-humble-ignition-cmake2-vendor.x86_64     | 2     |
| ignition-common  | 3          | x                                            | x     |
| ignition-fuel-tool | 4        | x                                            | x     |
| ignition-math    | 6          | ros-humble-ignition-math6.x86_64             | 6     |
| ignition-msgs    | 5          | ros-humble-gazebo-msgs.x86_64                | unknown |
| ignition-transport | 8        | x                                            | x     |


## 编译依赖

### Ignition common3


以下是该依赖的关系图：

- Ignition common3
  - ign-cmake0
  - ign-cmake2 **second**
    - tinyxml2 -> yum
    - ~~libdl -> yum~~smmg
    - uuid -> yum
    - FreeImage
    - gts
    - libswscale
    - libavdevice  -> yum
    - libavformat
    - libavcodec
    - libavutil

特别说明：

1. 以下这四个库可以通过 yum 安装 ffmpeg 直接安装：
- libswscale
- libavformat
- libavcodec
- libavutil

1. FreeImage 虽然 yum 可以直接安装，但是版本不符合，需要手动编译：

[FreeImage 下载](https://sourceforge.net/projects/freeimage/files/Source%20Distribution/3.18.0/FreeImage3180.zip/download?use_mirror=nchc)

其中 FreeImage 需要修改其目录下的 Makefile.gnu，改动如下：

安装路径修改

```
CXXFLAGS ?= -O3 -fPIC -fexceptions -fvisibility=hidden -Wno-ctor-dtor-privacy

-> CXXFLAGS ?= -O3 -fPIC -fexceptions -fvisibility=hidden -Wno-ctor-dtor-privacy -std=c++11
```

理由：在编译中遇到错误： `ISO C++17 does not allow dynamic exception specifications` 
该错误是因为在 C++17 标准中，不再允许使用动态异常规范，动态异常规范在 C++11 及更高版本中被弃用，所以需要将编译标准进行修改。

编译过程：

```
cd freeimage
make -f Makefile.gnu
sudo make -f Makefile.gnu install
```

编译后请确保 `pkg-config` 能够正确找到 Freeimage：

```
pkg-config --cflags --libs FreeImage
```
编译 gts：

```
wget https://gts.sourceforge.net/tarballs/gts-snapshot-121130.tar.gz
./configure
make
export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig:$PKG_CONFIG_PATH
```


### SDFormat

最后编译

> 官方要求：SDFormat 9 (SDF protocol <= 1.7)

在编译此以来前，需要先编译此依赖的依赖项以及其依赖项的依赖项等，以下为关系树：

- tinyxml -> yum
- urdfdom >=1.0 -> BFS
    - [urdfdom_headers](https://github.com/ros/urdfdom_headers.git)
    - [console-bridge](https://github.com/ros/console_bridge/archive/refs/tags/0.3.0.tar.gz) = 0.3

在完成以上所有的依赖项以及依赖项的依赖项的编译安装后，开始编译 ignition-tools：



完成 ignition-tools 的编译后，开始进行 SDFormat 9 的编译：

```
git clone https://github.com/gazebosim/sdformat -b sdf9
```

以下是该依赖的关系图：

- SDFormat
  - tinyxml
  - urdfdom 
    - urdfdom_headers
    - console-bridge
  - ignition-tools
    - ruby
    - tinyxml2

### Ignition Math 6 


依赖如下：
- swig -> yum
- python -> yum
- ruby -> yum

https://github.com/gazebosim/gz-math.git

### Ignition transport 8


依赖如下：

- zeromq-devel -> yum
- libtool -> yum
- [cppzmq](https://github.com/zeromq/czmq.git) -> BFS
- sqlite -> yum
- cppzmq-devel -> yum


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
```

https://github.com/gazebosim/gz-msgs.git -b ign-msgs5



### OGRE（BFS）

版本：1.10

OGRE 自身的源中包括了依赖，也就是不用另外手动编译其相关依赖，他可以在编译的过程中先自己编译自身所需的依赖。

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
## Cg don't
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

[source](https://ogrecave.github.io/ogre-next/api/latest/_setting_up_ogre_linux.html#BuildingDependenciesLinux)

### ignition-tools 

https://github.com/gazebosim/gz-tools.git -b ign-tools0

  - ruby -> yum
  - [tinyxml2](https://github.com/gazebosim/gz-tools.git) -> BFS

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

### qwt

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