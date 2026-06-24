# SuperRight

SuperRight 是一款轻量、原生的 macOS Finder 右键增强工具。它解决了 Finder 无法直接新建 TXT、Word、Excel 文件，以及复制完整路径步骤繁琐的问题。

安装并启用扩展后，无需打开主程序，只需在 Finder 中点击右键，即可完成日常文件操作。

## 为什么使用 SuperRight

在 Windows 中，我们可以直接通过右键菜单创建文件；但在 macOS Finder 中，系统默认只提供“新建文件夹”。当你需要创建文本文档、Word 文档或 Excel 工作簿时，通常必须先打开对应应用。

SuperRight 将这些常用操作直接放进 Finder 右键菜单：

- 不打开应用，直接在当前位置创建文件。
- 一键复制文件、文件夹或当前目录的完整绝对路径。
- 自动处理重名文件，不覆盖已有内容。
- 完全本地运行，不上传文件，不需要网络。

## 主要功能

### 新建文件

在 Finder 空白处或文件夹上点击右键，可创建：

- `新建文本文档.txt`
- `新建Word文档.docx`
- `新建Excel工作簿.xlsx`

TXT 是空白 UTF-8 文件，Word 和 Excel 使用有效的空白 OOXML 模板，可直接使用 Microsoft Office、WPS Office 或其他兼容软件打开。

如果已存在同名文件，SuperRight 会自动创建 `新建文本文档2.txt`、`新建文本文档3.txt` 等文件，绝不会覆盖原文件。

### 拷贝完整路径

右键选择“拷贝路径”，即可复制：

- 当前 Finder 目录的绝对路径。
- 包含文件夹名称的完整文件夹路径。
- 包含文件名及扩展名的完整文件路径。
- 多选项目时，每个完整路径占一行。

复制结果不会添加引号、转义符或多余的尾部斜杠，可以直接粘贴到终端、编辑器或聊天窗口。

### 智能右键菜单

| 右键位置 | 新建文件 | 拷贝路径 |
| --- | --- | --- |
| Finder 空白处 | 创建到当前目录 | 复制当前目录路径 |
| 文件夹 | 创建到该文件夹内部 | 复制该文件夹完整路径 |
| 文件 | 不显示 | 复制包含文件名和扩展名的完整路径 |
| 多选文件夹 | 创建到实际右键点击的文件夹 | 逐行复制全部路径 |
| 文件与文件夹混合多选 | 不显示 | 逐行复制全部路径 |

## 产品特点

- 原生 Swift 与 SwiftUI 开发。
- 支持 macOS 15 及以上系统。
- 主程序无需常驻，退出后 Finder 右键功能仍然可用。
- 不包含登录启动、自动更新、遥测或网络请求。
- 文件处理全部在本机完成。

## 安装与使用

获得正式的 SuperRight 安装包后：

1. 打开 `SuperRight.dmg`。
2. 将 `SuperRight.app` 拖入“应用程序”文件夹。
3. 从“应用程序”或 Spotlight 打开 SuperRight。
4. 点击“打开扩展设置”。
5. 在系统设置的“文件扩展”中启用 SuperRight。
6. 返回 SuperRight，看到“Finder 扩展已启用”后点击“完成并退出”。
7. 打开 Finder，在空白处、文件夹或文件上点击右键即可使用。

退出 SuperRight 主程序不会关闭右键功能。需要停用时，请重新打开 SuperRight，进入扩展设置并关闭 SuperRight 文件扩展。

如果启用后右键菜单没有立即出现，可重新打开 Finder；极少数情况下需要注销并重新登录系统。

## 从源码运行

### 环境要求

- macOS 15 或更高版本。
- 支持当前 macOS SDK 的完整版本 Xcode。

### 运行步骤

1. 下载或克隆本项目。
2. 双击打开 `SuperRight.xcodeproj`，不要打开 `Package.swift`。
3. 在 Xcode 顶部选择 `SuperRight` Scheme 和 `My Mac` 运行目标。
4. 如果 Xcode 提示签名错误，在两个 Target 的 `Signing & Capabilities` 中选择同一个开发团队：
   - `SuperRight`
   - `SuperRightFinderExtension`
5. 如果 Bundle ID 与其他项目冲突，请同时修改主程序和扩展的 Bundle ID，并保持扩展 ID 从属于主程序 ID。
6. 点击 Xcode 左上角的运行按钮，或按 `Command + R`。
7. 在启动的 SuperRight 窗口中点击“打开扩展设置”，启用 Finder 扩展。
8. 返回 Finder 测试右键菜单。

开发期间 Xcode 会从 DerivedData 运行应用。准备提供给其他用户时，应使用稳定的 Bundle ID、Developer ID 正式签名与 Apple 公证，并将应用制作成 DMG 安装包。

## 测试

核心逻辑可以通过以下命令测试：

```sh
swift test
```

Finder 右键菜单、剪贴板、系统扩展状态以及 Office 文件打开能力，需要在真实 macOS Finder 环境中进行集成测试。

## 停用与卸载

只退出 SuperRight 主程序不会停用 Finder 扩展。

- 暂时停用：在系统设置的“文件扩展”中关闭 SuperRight。
- 完全卸载：先关闭扩展，再将 `SuperRight.app` 移到废纸篓。

## 隐私

SuperRight 不收集用户数据，不读取或上传文件内容，也不连接任何网络服务。应用只在用户主动执行右键命令时，在所选目录创建文件或将路径写入系统剪贴板。
