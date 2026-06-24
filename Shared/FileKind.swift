import Foundation

enum FileKind: CaseIterable, Equatable, Sendable {
    case text
    case word
    case excel

    var defaultBaseName: String {
        switch self {
        case .text:
            "新建文本文档"
        case .word:
            "新建Word文档"
        case .excel:
            "新建Excel工作簿"
        }
    }

    var pathExtension: String {
        switch self {
        case .text:
            "txt"
        case .word:
            "docx"
        case .excel:
            "xlsx"
        }
    }

    var contents: Data {
        switch self {
        case .text:
            Data()
        case .word:
            OfficeTemplates.word
        case .excel:
            OfficeTemplates.excel
        }
    }
}
