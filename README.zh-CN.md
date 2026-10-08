# NeoDesk Rainmeter 皮肤

NeoDesk 是一套紧凑的 Rainmeter 桌面皮肤，包含时钟、问候卡片、网络状态、系统监控和一个 121 段音频可视化器。

## 功能

- **System** — CPU 占用率与实时频率、内存物理/提交占用，以及双显卡共享进度条。
- **Clock** — 居中的大号时间和日期卡片。
- **Network** — SSID、信号强度、内网 IP、公网 IP 和实时网速。
- **Greeting** — 按时段问候、Windows 账户头像和随机句子。
- **Visualizer** — 121 段音频可视化器，支持反射开关和左右声道变体。

## 环境要求

- Windows 10 1709 或更高，推荐 Windows 11。
- Rainmeter 4.5 或更高。
- 内置 MiSans 字体和 Rainmeter 插件，无需额外安装第三方 Rainmeter 插件。

## 安装

1. 从 [releases](releases) 下载最新的 `NeoDesk_<version>.zip`。
2. 将其中的 `NeoDesk` 文件夹解压到 Rainmeter 的 `Skins` 目录。
3. 打开 Rainmeter，刷新全部皮肤，然后启用你需要的布局。

详细说明见 [docs/INSTALL.md](docs/INSTALL.md)。

## 本地构建

```powershell
.\build.ps1
```

默认会生成类似 `dev+202610082045` 的开发版本。

构建指定版本：

```powershell
.\build.ps1 -Version 1.2.0
```

输出位置：

- `dist\NeoDesk_<version>.zip`
- `dist\NeoDesk_<version>.zip.sha256`

详见 [docs/BUILD.md](docs/BUILD.md)。

## 版本规则

- 开发版使用 `dev+yyyyMMddHHmm`。
- 发布版使用 Git 标签名，例如 `v1.2.0` 对应 `1.2.0`。
- 手动传入 `-Version` 时优先使用输入值。

详见 [docs/VERSIONING.md](docs/VERSIONING.md)。

## 许可证

MIT，见 [LICENSE](LICENSE)。

## 致谢

见 [docs/CREDITS.md](docs/CREDITS.md)。
