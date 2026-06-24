import Foundation

private func check(_ condition: @autoclosure () -> Bool, _ message: String) {
    guard condition() else {
        fatalError("Core check failed: \(message)")
    }
}

let root = URL(fileURLWithPath: "/测试")
let folder = root.appendingPathComponent("资料")
let file = root.appendingPathComponent("说明.txt")
let contextBuilder = FinderMenuContextBuilder { $0.pathExtension.isEmpty }

let containerContext = contextBuilder.makeContext(
    source: .container,
    targetedURL: root,
    selectedURLs: []
)
check(containerContext?.creationDirectory == root, "空白处应在当前目录创建")
check(containerContext?.pathsToCopy == [root], "空白处应复制当前目录")

let folderContext = contextBuilder.makeContext(
    source: .items,
    targetedURL: folder,
    selectedURLs: [folder]
)
check(folderContext?.creationDirectory == folder, "文件夹菜单应在目标文件夹内创建")
check(folderContext?.pathsToCopy == [folder], "文件夹菜单应复制完整文件夹路径")

let mixedContext = contextBuilder.makeContext(
    source: .items,
    targetedURL: folder,
    selectedURLs: [folder, file]
)
check(mixedContext?.creationDirectory == nil, "混合多选不应允许创建")
check(mixedContext?.pathsToCopy == [folder, file], "混合多选应保留全部路径")

check(OfficeTemplates.word.starts(with: [0x50, 0x4B]), "Word 模板应为 ZIP")
check(OfficeTemplates.excel.starts(with: [0x50, 0x4B]), "Excel 模板应为 ZIP")
check(
    ClipboardPathFormatter.string(for: [folder, file]) == "\(folder.path)\n\(file.path)",
    "多个路径应逐行连接"
)

let temporaryDirectory = FileManager.default.temporaryDirectory
    .appendingPathComponent(UUID().uuidString, isDirectory: true)
try FileManager.default.createDirectory(at: temporaryDirectory, withIntermediateDirectories: true)
defer { try? FileManager.default.removeItem(at: temporaryDirectory) }

let creator = UniqueFileCreator()
let first = try creator.create(.text, in: temporaryDirectory)
try Data("保留".utf8).write(to: first)
let second = try creator.create(.text, in: temporaryDirectory)
check(first.lastPathComponent == "新建文本文档.txt", "首个文件名不正确")
check(second.lastPathComponent == "新建文本文档2.txt", "重名序号不正确")
let preservedContents = try String(contentsOf: first, encoding: .utf8)
check(preservedContents == "保留", "已有文件被覆盖")

print("All SuperRight core checks passed.")
