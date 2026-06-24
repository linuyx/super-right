# SuperRight

SuperRight 是一个面向 macOS 15 及以上系统的原生 Finder 扩展，在右键菜单中提供新建 TXT、Word、Excel 文件和拷贝完整路径功能。

## 构建

1. 安装完整版本的 Xcode 16 或更高版本。
2. 打开 `SuperRight.xcodeproj`。
3. 在项目的 Signing & Capabilities 中为 `SuperRight` 和 `SuperRightFinderExtension` 选择同一个开发团队；如 Bundle ID 冲突，请一并修改两个 Target 的 Bundle ID。
4. 运行 `SuperRight` Scheme。
5. 在应用中点击“打开扩展设置”，启用 SuperRight Finder 扩展。

扩展启用后，如果 Finder 菜单没有立即刷新，可退出并重新打开 Finder。

## 测试

安装完整 Xcode 后，可以运行：

```sh
swift test
```

当前仓库还包含不依赖 XCTest 的 `CoreChecks/main.swift`，用于在精简构建环境中验证同一组核心行为。Finder 菜单、系统剪贴板和 Office 文件打开能力仍需在安装完整 Xcode 后进行真机集成测试。

> Finder Sync 扩展必须启用 App Sandbox。当前自用版本通过临时绝对路径读写权限支持在任意 Finder 目录新建文件；该权限不适用于 Mac App Store 发布版本。
