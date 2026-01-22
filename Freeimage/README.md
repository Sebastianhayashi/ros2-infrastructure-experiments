# Freeimage

## 仓库使用

```
curl -sSL https://raw.githubusercontent.com/Sebastianhayashi/Freeimage/main/build.sh | bash
```

编译顺序：4

Version：3.18.0
Source：http://downloads.sourceforge.net/freeimage/FreeImage3180.zip

## 改动说明

编译中的错误：`ISO C++17 does not allow dynamic exception `

这些错误是因为在 C++17 标准中，不再允许使用动态异常规范（例如 throw(IEX_NAMESPACE::MathExc)）。动态异常规范在 C++11 及更高版本中被弃用，在 C++17 中被完全删除。

所以在 Makefile 中将标准更改为：`c++11`

改动文件：Makefile.gnu

## 编译过程

```
cd freeimage
make -f Makefile.gnu
sudo make -f Makefile.gnu install
```

编译后请确保 `pkg-config` 能够正确找到 Freeimage：

```
pkg-config --cflags --libs FreeImage
```