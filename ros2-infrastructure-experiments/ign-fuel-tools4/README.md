# ign-fuel-tools4

## 仓库使用

```
curl -sSL https://raw.githubusercontent.com/Sebastianhayashi/ign-fuel-tools4/main/build.sh | bash
```

## 基本信息

编译顺序：8
版本：ignition-fuel_tools4 VERSION 4.9.1

依赖：

- libcurl-devel -> yum
- jsoncpp-devel -> yum
- libyaml-devel -> yum
- libzip-devel -> yum

ign fuel tools 的编译还需要：https://github.com/Tobias-Fischer/ign-tools.git

ign-tools 编译方式：
mkdir build
cd build
cmake .. -DCMAKE_INSTALL_PREFIX=/usr
sudo make install