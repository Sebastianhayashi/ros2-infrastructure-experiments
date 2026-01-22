# ogre

## 仓库使用

```
curl -sSL https://raw.githubusercontent.com/Sebastianhayashi/ogre/main/build.sh | bash
```

## 基本信息

编译顺序：10
版本：v10.0.0

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