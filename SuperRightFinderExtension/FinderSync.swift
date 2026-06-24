import AppKit
import FinderSync

final class FinderSync: FIFinderSync {
    private let contextBuilder = FinderMenuContextBuilder()

    override init() {
        super.init()
        FIFinderSyncController.default().directoryURLs = [
            URL(fileURLWithPath: "/", isDirectory: true),
        ]
    }

    override func menu(for menuKind: FIMenuKind) -> NSMenu? {
        let source: FinderMenuSource
        switch menuKind {
        case .contextualMenuForContainer:
            source = .container
        case .contextualMenuForItems:
            source = .items
        default:
            return nil
        }

        let controller = FIFinderSyncController.default()
        guard let context = contextBuilder.makeContext(
            source: source,
            targetedURL: controller.targetedURL(),
            selectedURLs: controller.selectedItemURLs() ?? []
        ) else {
            return nil
        }

        let menu = NSMenu(title: "SuperRight")
        if context.allowsFileCreation {
            menu.addItem(makeCreateMenu())
        }

        menu.addItem(
            withTitle: "拷贝路径",
            action: #selector(copyPaths(_:)),
            keyEquivalent: ""
        )
        return menu
    }

    private func makeCreateMenu() -> NSMenuItem {
        let parent = NSMenuItem(title: "新建文件", action: nil, keyEquivalent: "")
        let submenu = NSMenu(title: "新建文件")

        submenu.addItem(
            withTitle: "新建 TXT 文件",
            action: #selector(createTextFile(_:)),
            keyEquivalent: ""
        )
        submenu.addItem(
            withTitle: "新建 Word 文档",
            action: #selector(createWordFile(_:)),
            keyEquivalent: ""
        )
        submenu.addItem(
            withTitle: "新建 Excel 工作簿",
            action: #selector(createExcelFile(_:)),
            keyEquivalent: ""
        )

        parent.submenu = submenu
        return parent
    }

    @IBAction nonisolated func createTextFile(_ sender: AnyObject?) {
        requestCreation(of: .text)
    }

    @IBAction nonisolated func createWordFile(_ sender: AnyObject?) {
        requestCreation(of: .word)
    }

    @IBAction nonisolated func createExcelFile(_ sender: AnyObject?) {
        requestCreation(of: .excel)
    }

    private nonisolated func requestCreation(of kind: FileKind) {
        let directory = FIFinderSyncController.default().targetedURL()
        Task { @MainActor in
            Self.create(kind, in: directory)
        }
    }

    @MainActor
    private static func create(_ kind: FileKind, in directory: URL?) {
        guard let directory,
              FinderMenuContextBuilder.defaultDirectoryClassifier(directory) else {
            showError(title: "无法创建文件", message: "Finder 没有提供有效的目标文件夹。")
            return
        }

        NSLog("SuperRight: creating %@ in %@", kind.pathExtension, directory.path)
        do {
            try UniqueFileCreator().create(kind, in: directory)
        } catch {
            NSLog("SuperRight: create failed: %@", error.localizedDescription)
            showError(title: "无法创建文件", message: error.localizedDescription)
        }
    }

    @IBAction nonisolated func copyPaths(_ sender: AnyObject?) {
        let controller = FIFinderSyncController.default()
        let selectedURLs = controller.selectedItemURLs() ?? []
        let urls = selectedURLs.isEmpty ? controller.targetedURL().map { [$0] } ?? [] : selectedURLs

        Task { @MainActor in
            Self.copyPaths(urls)
        }
    }

    @MainActor
    private static func copyPaths(_ urls: [URL]) {
        guard !urls.isEmpty else {
            showError(title: "无法拷贝路径", message: "Finder 没有提供有效路径。")
            return
        }

        NSLog("SuperRight: copying %ld path(s)", urls.count)
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        guard pasteboard.setString(ClipboardPathFormatter.string(for: urls), forType: .string) else {
            showError(title: "无法拷贝路径", message: "无法写入系统剪贴板。")
            return
        }
    }

    @MainActor
    private static func showError(title: String, message: String) {
        let alert = NSAlert()
        alert.alertStyle = .warning
        alert.messageText = title
        alert.informativeText = message
        alert.addButton(withTitle: "好")
        alert.runModal()
    }
}
