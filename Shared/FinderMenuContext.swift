import Foundation

enum FinderMenuSource: Sendable {
    case container
    case items
}

struct FinderMenuContext: Equatable, Sendable {
    let creationDirectory: URL?
    let pathsToCopy: [URL]

    var allowsFileCreation: Bool {
        creationDirectory != nil
    }
}

struct FinderMenuContextBuilder {
    typealias DirectoryClassifier = (URL) -> Bool

    private let isPlainDirectory: DirectoryClassifier

    init(
        isPlainDirectory: @escaping DirectoryClassifier = FinderMenuContextBuilder.defaultDirectoryClassifier
    ) {
        self.isPlainDirectory = isPlainDirectory
    }

    func makeContext(
        source: FinderMenuSource,
        targetedURL: URL?,
        selectedURLs: [URL]
    ) -> FinderMenuContext? {
        guard let targetedURL, targetedURL.isFileURL else {
            return nil
        }

        switch source {
        case .container:
            guard isPlainDirectory(targetedURL) else {
                return nil
            }
            return FinderMenuContext(
                creationDirectory: targetedURL,
                pathsToCopy: [targetedURL]
            )

        case .items:
            let items = selectedURLs.isEmpty ? [targetedURL] : selectedURLs
            let containsOnlyFolders = items.allSatisfy(isPlainDirectory)
            return FinderMenuContext(
                creationDirectory: containsOnlyFolders && isPlainDirectory(targetedURL) ? targetedURL : nil,
                pathsToCopy: items
            )
        }
    }

    static func defaultDirectoryClassifier(_ url: URL) -> Bool {
        guard url.isFileURL else { return false }

        do {
            let values = try url.resourceValues(forKeys: [
                .isDirectoryKey,
                .isPackageKey,
                .isAliasFileKey,
                .isSymbolicLinkKey,
            ])
            return values.isDirectory == true
                && values.isPackage != true
                && values.isAliasFile != true
                && values.isSymbolicLink != true
        } catch {
            return url.hasDirectoryPath
        }
    }
}
