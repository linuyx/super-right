import Foundation
import XCTest
@testable import SuperRightCore

final class FinderMenuContextTests: XCTestCase {
    private let root = URL(fileURLWithPath: "/测试")

    private var builder: FinderMenuContextBuilder {
        FinderMenuContextBuilder { $0.pathExtension.isEmpty }
    }

    func testContainerUsesCurrentDirectory() {
        let context = builder.makeContext(source: .container, targetedURL: root, selectedURLs: [])
        XCTAssertEqual(context?.creationDirectory, root)
        XCTAssertEqual(context?.pathsToCopy, [root])
    }

    func testFolderCreatesInsideTarget() {
        let first = root.appendingPathComponent("第一层")
        let second = root.appendingPathComponent("第二层")
        let context = builder.makeContext(
            source: .items,
            targetedURL: second,
            selectedURLs: [first, second]
        )
        XCTAssertEqual(context?.creationDirectory, second)
        XCTAssertEqual(context?.pathsToCopy, [first, second])
    }

    func testFilesOnlyCopyPaths() {
        let file = root.appendingPathComponent("报告.docx")
        let context = builder.makeContext(source: .items, targetedURL: file, selectedURLs: [file])
        XCTAssertNil(context?.creationDirectory)
        XCTAssertEqual(context?.pathsToCopy, [file])
    }

    func testMixedSelectionOnlyCopies() {
        let folder = root.appendingPathComponent("资料")
        let file = root.appendingPathComponent("说明.txt")
        let context = builder.makeContext(
            source: .items,
            targetedURL: folder,
            selectedURLs: [folder, file]
        )
        XCTAssertNil(context?.creationDirectory)
        XCTAssertEqual(context?.pathsToCopy, [folder, file])
    }

    func testMissingTargetProducesNoContext() {
        XCTAssertNil(builder.makeContext(source: .container, targetedURL: nil, selectedURLs: []))
    }
}
