# ign-transport8

## 仓库使用

```
curl -sSL https://raw.githubusercontent.com/Sebastianhayashi/ign-transport8/main/build.sh | bash
```

## 基本信息

编译顺序：7
版本：ignition-transport8 VERSION 8.5.0

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