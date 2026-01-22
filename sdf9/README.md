# sdf9

## 仓库使用

```
curl -sSL https://raw.githubusercontent.com/Sebastianhayashi/sdf9/main/build.sh | bash
```

## 基本信息

编译顺序：11
版本：VERSION 3.10.2

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
