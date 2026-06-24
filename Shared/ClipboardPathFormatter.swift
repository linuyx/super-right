import Foundation

enum ClipboardPathFormatter {
    static func string(for urls: [URL]) -> String {
        urls.map(\.path).joined(separator: "\n")
    }
}
