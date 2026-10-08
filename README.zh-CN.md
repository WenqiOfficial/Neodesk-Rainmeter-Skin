# NeoDesk Rainmeter 皮肤

[English](README.md) | [简体中文](README.zh-CN.md)

[![Release](https://img.shields.io/github/v/release/WenqiOfficial/Neodesk-Rainmeter-Skin?style=flat-square)](https://github.com/WenqiOfficial/Neodesk-Rainmeter-Skin/releases)
[![License](https://img.shields.io/github/license/WenqiOfficial/Neodesk-Rainmeter-Skin?style=flat-square)](LICENSE)
[![Platform](https://img.shields.io/badge/platform-Windows-blue?style=flat-square)](#)

NeoDesk 是一套为 Windows 设计的紧凑型 Rainmeter 皮肤，包含时钟、问候卡片、网络状态、系统监控和 121 段音频可视化器，整体采用统一的深色卡片风格。

## 功能

- **System** — CPU 占用率与实时频率、内存物理/提交占用，以及双显卡共享进度条。
- **Clock** — 居中的大号时间和日期卡片。
- **Network** — SSID、信号强度、内网 IP、公网 IP 和实时网速。
- **Greeting** — 按时段问候、Windows 账户头像和随机句子。
- **Visualizer** — 121 段音频可视化器，支持反射开关和左右声道变体。

## 环境要求

- Windows 10 1709 或更高。
- Rainmeter 4.5 或更高。
- 无需额外安装第三方 Rainmeter 插件。

## 安装

1. 从 [releases](https://github.com/WenqiOfficial/Neodesk-Rainmeter-Skin/releases) 下载最新的 `NeoDesk_<version>.zip`。
2. 将 `NeoDesk` 文件夹解压到 Rainmeter 的 `Skins` 目录。
3. 刷新 Rainmeter 并启用你需要的布局。

详细说明见 [docs/INSTALL.md](docs/INSTALL.md)。

## 构建

```powershell
.\build.ps1
```

默认会生成类似 `NeoDesk_dev+202610082045.zip` 的开发包。

构建发布包：

```powershell
.\build.ps1 -Release 1.2.0
```

输出位置：

- `dist\NeoDesk_<version>.zip`
- `dist\NeoDesk_<version>.zip.sha256`

详见 [docs/BUILD.md](docs/BUILD.md)。

## 发布

推送 `v1.2.0` 这类 tag 后，GitHub Actions 会自动：

1. 构建皮肤包。
2. 从 `CHANGELOG.md` 生成 release 内容。
3. 发布 GitHub Release 并附带 zip 和校验文件。

## 项目结构

```text
NeoDesk/
  @Resources/
    Fonts/
    Images/
    Language/
    Scripts/
    Text/
    Theme/
  Clock/
  Greeting/
  Network/
  System/
  Visualizer/
  Visualizer_L/
  Visualizer_R/
```

更多结构说明见 [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md)。

## 文档

- [安装与配置](docs/INSTALL.md)
- [构建与发布](docs/BUILD.md)
- [架构说明](docs/ARCHITECTURE.md)
- [GPU 统计口径](docs/GPU_METRICS.md)
- [致谢](docs/CREDITS.md)

## 许可证

MIT，见 [LICENSE](LICENSE)。
