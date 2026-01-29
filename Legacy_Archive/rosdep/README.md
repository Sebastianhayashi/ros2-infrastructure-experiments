# 📂 Legacy Archive: The "Source Intrusion" Anti-Pattern (Rosdep)

> **⚠️ Deprecated / 仅作技术归档**
> 本目录包含了项目早期尝试修改 `rosdep` 源码以注册 openEuler 系统的遗留代码。**这种侵入式修改（Invasive Modification）已被证明是不可持续的，现已被“系统伪装”策略取代。**

---

## 🛑 The Problem: Hard-coded OS Registration

在尝试支持 openEuler 的初期，我们面临的一个根本性阻碍是：**`rosdep` 无法原生识别未知的 Linux 发行版。**

要让 `rosdep` 能够运行，仅仅有 YAML 规则表是不够的，我们必须深入其 Python 源码，在核心逻辑中“注册”这个新系统。

### 🔗 The Evidence (源码侵入证据)

参考以下 Commit，展示了为了让工具链识别一个新系统，我们需要修改多少底层代码：
**[Commit: Register openEuler in rosdep source](https://github.com/ros-infrastructure/rosdep/commit/139dde1bfa4cb58f6cfc6ede07f297c25c3de236)**

在此过程中，我们被迫修改了 `rosdep2/platforms` 等核心模块：
1.  **Define OS Key**: 在常量定义中硬编码 `OS_OPENEULER = 'openeuler'`。
2.  **Patch Detection Logic**: 修改 `os_detect.py`，增加读取 `/etc/os-release` 并匹配 openEuler 的特定逻辑。
3.  **Package Manager Mapping**: 在源码级别绑定 `dnf`/`yum` 为该 OS 的默认包管理器。

---

## 📉 Why is this Fatal? (为何这是致命的)

这种“源码级侵入”虽然在技术上让 `rosdep` 跑通了，但它带来了无法接受的工程代价：

### 1. The "Fork" Trap (分支陷阱)
一旦修改了源码，我们就不能直接使用 `pip install rosdep` 安装官方版本。
* **后果:** 用户必须卸载官方版本，安装我们维护的 `rosdep-openeuler` 修改版。这对用户环境是极其不友好的（Polluting User Environment）。

### 2. Upstream Decoupling (与上游脱钩)
ROS 官方的 `rosdep` 经常更新（修复 Bug、优化性能）。
* **后果:** 我们的修改版会迅速过时。为了保持同步，我们需要不断地 Rebase 上游代码，处理复杂的 Merge Conflicts。这实际上是在维护一个独立的软件发行版，而非一个移植工具。

### 3. Scalability Issues (扩展性差)
如果明天我们要支持 OpenKylin 或 Deepin，我们必须再次侵入源码，重复上述所有步骤。这违背了“自动化通用构建”的初衷。

---

## 🚀 The Paradigm Shift: "Masquerade" (伪装策略)

在 **EulerROS-Automation** 的现行架构中，我们通过 **System Masquerade (系统伪装)** 彻底规避了源码修改。

我们不再请求 `rosdep` 识别 openEuler，而是欺骗它：

* **Old Way (Invasive):** 修改源码，将 openEuler 强行注册的 rosdep 中。
* **New Way (Zero-Invasive):** 注入环境变量 `ROS_OS_OVERRIDE=rhel:9`。

**Result:**
通过伪装成 RHEL，我们直接复用了 `rosdep` 官方源码中对 RHEL 的所有定义和逻辑。**我们不需要修改 rosdep 的任何一行代码，即可直接使用官方发布的工具链。**

> *"The best code is no code." —— 我们删除了所有针对 rosdep 源码的修改，实现了真正的零侵入。*