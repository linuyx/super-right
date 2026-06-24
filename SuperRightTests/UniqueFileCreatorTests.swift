import Foundation
import XCTest
@testable import SuperRightCore

final class UniqueFileCreatorTests: XCTestCase {
    func testIncrementsNamesWithoutOverwriting() throws {
        let directory = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString, isDirectory: true)
        try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
        defer { try? FileManager.default.removeItem(at: directory) }

        let creator = UniqueFileCreator()
        let first = try creator.create(.text, in: directory)
        try Data("保留".utf8).write(to: first)
        let second = try creator.create(.text, in: directory)

        XCTAssertEqual(first.lastPathComponent, "新建文本文档.txt")
        XCTAssertEqual(second.lastPathComponent, "新建文本文档2.txt")
        XCTAssertEqual(try String(contentsOf: first, encoding: .utf8), "保留")
    }

    func testOfficeTemplatesAreZipPackages() {
        XCTAssertTrue(OfficeTemplates.word.starts(with: [0x50, 0x4B]))
        XCTAssertTrue(OfficeTemplates.excel.starts(with: [0x50, 0x4B]))
        XCTAssertGreaterThan(OfficeTemplates.word.count, 500)
        XCTAssertGreaterThan(OfficeTemplates.excel.count, 500)
    }

    func testFormatsClipboardPaths() {
        let urls = [
            URL(fileURLWithPath: "/用户/资料/文档.docx"),
            URL(fileURLWithPath: "/用户/资料/图片 1.png"),
        ]
        XCTAssertEqual(
            ClipboardPathFormatter.string(for: urls),
            "/用户/资料/文档.docx\n/用户/资料/图片 1.png"
        )
    }
}
