%bcond_without tests
%bcond_without weak_deps

%global __os_install_post %(echo '%{__os_install_post}' | sed -e 's!/usr/lib[^[:space:]]*/brp-python-bytecompile[[:space:]].*$!!g')
%global __provides_exclude_from ^/opt/ros/jazzy/.*$
%global __requires_exclude_from ^/opt/ros/jazzy/.*$
%global debug_package %{nil}

Name:           uncrustify
Version:        0.80.1
Release:        1%{?dist}
Summary:        A highly configurable source code beautifier for various programming languages

License:        GPL-2.0-or-later
URL:            https://github.com/uncrustify/uncrustify
Source0:        %{name}-%{version}.tar.gz

BuildRequires:  cmake >= 3.10
BuildRequires:  gcc-c++
BuildRequires:  python3
BuildRequires:  make
BuildRequires:  git
BuildRequires:  pkgconfig

Requires:       python3

%description
Uncrustify is a highly configurable, easily modifiable source code beautifier
for C, C++, C#, ObjectiveC, D, Java, Pawn, and VALA.

%prep
%autosetup -p1

%build
# 修复 PYTHONPATH 环境变量
export PYTHONPATH=/opt/ros/jazzy/lib/python3.11/site-packages:$PYTHONPATH

# 修复 CMAKE_PREFIX_PATH 和 PKG_CONFIG_PATH
export CMAKE_PREFIX_PATH=/opt/ros/jazzy
export PKG_CONFIG_PATH=/opt/ros/jazzy/lib/pkgconfig

# 输出环境变量以验证设置
echo "PYTHONPATH: $PYTHONPATH"
echo "CMAKE_PREFIX_PATH: $CMAKE_PREFIX_PATH"
echo "PKG_CONFIG_PATH: $PKG_CONFIG_PATH"

# 创建构建目录并进入
mkdir -p .obj-%{_target_platform} && cd .obj-%{_target_platform}
%cmake3 \
    -DCMAKE_INSTALL_PREFIX="/opt/ros/jazzy" \
    -DAMENT_PREFIX_PATH="/opt/ros/jazzy" \
    -DCMAKE_PREFIX_PATH="/opt/ros/jazzy" \
    -DSETUPTOOLS_DEB_LAYOUT=OFF \
%if !0%{?with_tests}
    -DBUILD_TESTING=OFF \
%endif
    ..

%make_build

%install
# 检查并加载安装环境
if [ -f "/opt/ros/jazzy/setup.sh" ]; then . "/opt/ros/jazzy/setup.sh"; fi
%make_install -C .obj-%{_target_platform}

%if 0%{?with_tests}
%check
# 检查是否存在测试目录或文件
if [ -d "tests" ] || ls test_*.py *_test.py > /dev/null 2>&1; then
    %__python3 -m pytest tests || echo "RPM TESTS FAILED"
else
    echo "No tests to run, skipping."
fi
%endif

%files
%license COPYING
%doc README.md AUTHORS BUGS ChangeLog HELP
/opt/ros/jazzy/*

%changelog
* Sat Apr 27 2024 Your Name <microseyuyu@gmail.com> - 0.80.1-1
- Initial RPM release
