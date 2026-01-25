# Ignition-msgs5

## 仓库使用

```
curl -sSL https://raw.githubusercontent.com/Sebastianhayashi/ignition-msgs5/main/build.sh | bash
```

## 仓库说明

编译顺序：6
版本：ignition-msgs5 VERSION 5.11.0

依赖：

- protobuf -> build from source
  -   bazel -> yum
  

编译过程：

```
git clone https://github.com/protocolbuffers/protobuf.git -b 23.x
git submodule update --init --recursive
cd cmake
cmake ..
make -j8
sudo make install

export PKG_CONFIG_PATH=/usr/local/lib64/pkgconfig:$PKG_CONFIG_PATH


```