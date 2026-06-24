import Foundation

enum FileCreationError: LocalizedError, Equatable {
    case invalidTarget(URL)
    case missingTemplate(FileKind)
    case unableToCreate(URL, String)

    var errorDescription: String? {
        switch self {
        case .invalidTarget(let url):
            "目标文件夹无效：\(url.path)"
        case .missingTemplate(let kind):
            "无法读取 \(kind.pathExtension.uppercased()) 空白模板。"
        case .unableToCreate(let url, let reason):
            "无法在“\(url.path)”中创建文件。\n\(reason)"
        }
    }
}
